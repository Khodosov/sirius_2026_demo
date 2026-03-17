# Персистентность во Flutter — демо-проект

Демо-приложение для лекции по теме **Persistence** 

Каждый экран — отдельный пример работы с конкретным способом хранения данных.

## Экраны

| Экран | Пакет | Описание |
|-------|-------|----------|
| Local Storage | `path_provider` | `getApplicationDocumentsDirectory` vs `getTemporaryDirectory` |
| Shared Preferences | `shared_preferences` | Key-value хранилище для простых данных |
| Hive | `hive`, `hive_flutter` | Быстрая NoSQL база данных |
| Isar | `isar`, `isar_flutter_libs` | NoSQL база данных с поддержкой запросов |
| sqflite | `sqflite` | SQLite для Flutter |
| Secure Storage | `flutter_secure_storage` | Безопасное хранение (Keychain / Keystore) |

---

## sqflite

### Общая информация

- **sqflite** — обёртка над **SQLite** для Flutter/Dart: реляционная БД в одном файле на диске.
- Полноценный **SQL**: таблицы, индексы, JOIN, транзакции, миграции через версию.
- Пакет: `sqflite` (mobile); для desktop — `sqflite_common_ffi` + `path`/`path_provider`.
- Файл БД обычно кладут в директорию приложения (например, через `getDatabasesPath()`).

### Изоляты и работа в фоне

- Операции с БД (открытие, запросы, запись) **асинхронные** (`Future`) и не блокируют UI.
- На мобильных платформах sqflite выполняет работу в **фоновом изоляте** — тяжёлые запросы не подвешивают главный поток.
- В коде всегда **await**: `openDatabase(...)`, `db.query()`, `db.insert()` и т.д. Инициализацию лучше выполнить при старте приложения и хранить экземпляр `Database`.

```
  UI (main isolate)          Фон (другой isolate)
  ┌─────────────────┐        ┌─────────────────┐
  │ await db.query()│ ─────► │ SQLite engine   │
  │ await db.insert()│       │ выполнение      │
  └─────────────────┘        └─────────────────┘
         не блокирует UI
```

### Открытие БД

1. **Путь к папке БД:** `getDatabasesPath()` (возвращает платформенный каталог для баз).
2. **Полный путь к файлу:** склеить с именем файла (например, через `path.join(dbPath, 'app.db')`).
3. **Открытие:** `openDatabase(path, version: N, onCreate: ..., onUpgrade: ...)`.

При первом запуске вызывается **onCreate** — создание таблиц. При увеличении **version** в следующих сборках — **onUpgrade** (миграции).

### Пример: открытие и создание таблицы

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> openAppDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'app.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE items (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL
        )
      ''');
    },
  );
}
```

### Миграции

- У БД есть **version** (целое число). При установке/первом запуске вызывается только **onCreate**.
- Когда вы поднимаете **version** (например, с 1 до 2), при следующем открытии вызывается **onUpgrade(db, oldVersion, newVersion)**.
- В **onUpgrade** выполняют ALTER TABLE, создание новых таблиц или перенос данных, чтобы схема соответствовала новой версии.

```
  version: 1  →  onCreate()   (первый запуск)
  version: 2  →  onUpgrade(db, 1, 2)  (добавить столбец, новую таблицу и т.д.)
```

### Источники

- [sqflite (pub.dev)](https://pub.dev/packages/sqflite)
- [Flutter: Persist data with SQLite](https://docs.flutter.dev/cookbook/persistence/sqlite)
- [SQLite documentation](https://www.sqlite.org/docs.html)

---

## Firestore

### Что такое Firestore?

- **Cloud Firestore** — облачная **документная NoSQL** база данных от Firebase (Google).
- Данные хранятся **на сервере**, не только на устройстве: синхронизация между пользователями и устройствами.
- Модель: **коллекции** → **документы** → поля (и вложенные подколлекции). Каждый документ — по сути JSON-объект с полями.
- Во Flutter: пакет **cloud_firestore**. Требуется настройка Firebase проекта.

### Модель данных

```
  Коллекция (collection)     Документ (document)      Поля (fields)
  ┌─────────────────┐        ┌─────────────────┐     ┌─────────────────┐
  │ users           │   ──►  │ id: "abc123"    │     │ name: "Anna"    │
  │                 │        │                 │     │ score: 42      │
  │ (много документов)       │ (уникальный id) │     │ createdAt: TS  │
  └─────────────────┘        └────────┬────────┘     └─────────────────┘
                                      │
                                      ▼ подколлекция
                              ┌─────────────────┐
                              │ orders          │
                              │   doc1, doc2…   │
                              └─────────────────┘
```

### Основные возможности

| Возможность | Описание |
|-------------|----------|
| **Real-time** | Подписка на коллекцию/документ — обновления приходят при изменении данных |
| **Offline** | Локальная кэш-копия включена по умолчанию; работает без сети |
| **Запросы** | where, orderBy, limit; индексы создаются в консоли Firebase |
| **Безопасность** | Security Rules — кто что может читать/писать |

### Когда использовать Firestore

- Нужна **синхронизация между устройствами** и пользователями.
- Нужны **real-time обновления** (чаты, совместное редактирование, лидерборды).
- Нужен **бэкенд без своего сервера**.
- **Не** заменяет локальную БД для чисто офлайн-данных: там уместны sqflite, Hive, Isar.

### Пример чтения/записи

```dart
final firestore = FirebaseFirestore.instance;

// запись
await firestore.collection('users').doc('user1').set({
  'name': 'Anna',
  'score': 42,
});

// чтение один раз
final doc = await firestore.collection('users').doc('user1').get();

// подписка на обновления (real-time)
firestore.collection('users').doc('user1').snapshots().listen((snapshot) {
  // snapshot.data() обновляется при любом изменении на сервере
});
```

### Источники

- [Firestore (Firebase)](https://firebase.google.com/docs/firestore)
- [cloud_firestore (pub.dev)](https://pub.dev/packages/cloud_firestore)
- [Flutter: Get started with Cloud Firestore](https://firebase.google.com/docs/firestore/quickstart#flutter)

---

## Secure Storage — что хранить

### Что такое Secure Storage?

- Хранилище с **шифрованием на уровне ОС**: на iOS — **Keychain**, на Android — **Keystore** (или EncryptedSharedPreferences).
- Данные не лежат в открытом виде в файловой системе приложения.
- Во Flutter: пакет **flutter_secure_storage**. API — ключ–значение (String → String), асинхронный.

### Что хранить

| Тип данных | Примеры |
|------------|--------|
| **Токены авторизации** | Access token, refresh token (OAuth, JWT) |
| **Пароли и PIN** | Пароль пользователя, PIN для входа |
| **Ключи и секреты** | API keys, криптографические ключи |
| **Чувствительные персональные данные** | Номера карт, данные для автозаполнения |

### Что не хранить

| Не хранить | Почему / куда |
|------------|----------------|
| Большие объёмы данных | Ограничения платформы и производительность; для кэша — файлы или БД |
| Несекретные настройки | Тема, язык, флаги — **SharedPreferences** |
| Данные для синхронизации | Секреты привязаны к устройству; общие данные — облако |

### Сравнение: где хранить

```
  Секреты (токены, пароли, ключи)
  → Secure Storage (Keychain / Keystore)  ✅

  Обычные настройки (тема, язык, флаги)
  → SharedPreferences  ✅

  Структурированные данные (не секреты)
  → sqflite, Hive, Isar  ✅
```

---

## flutter_secure_storage — API и платформы

### Основной API

| Метод | Назначение |
|-------|------------|
| `read(key: String)` | Прочитать значение по ключу; `Future<String?>` |
| `write(key: String, value: String)` | Записать пару ключ–значение |
| `delete(key: String)` | Удалить запись по ключу |
| `deleteAll()` | Удалить все записи |
| `containsKey(key: String)` | Проверить наличие ключа (`Future<bool>`) |
| `readAll()` | Прочитать все пары (`Future<Map<String, String>>`) |

### Пример использования

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();

// запись
await storage.write(key: 'access_token', value: 'eyJ...');

// чтение
final String? token = await storage.read(key: 'access_token');

// проверка и удаление
if (await storage.containsKey(key: 'access_token')) {
  await storage.delete(key: 'access_token');
}
```

### iOS: Keychain

- **Keychain** — системное хранилище паролей и ключей; данные шифруются ОС, привязаны к приложению (или к группе через App Group).
- flutter_secure_storage сохраняет записи в Keychain с идентификатором приложения.
- **Accessibility (IOSOptions):** когда данные доступны — только при разблокированном устройстве, после первой разблокировки и т.д.

### Android: Keystore и шифрование

- **Android Keystore** хранит криптографические ключи; ключи могут быть привязаны к аппаратной защите (TEE/StrongBox).
- flutter_secure_storage использует Keystore для хранения ключа шифрования; на части устройств используется **EncryptedSharedPreferences** (AES + Keystore).
- При удалении приложения записи Keystore удаляются.

```
  Flutter (Dart)
  ┌─────────────────────────────┐
  │  FlutterSecureStorage()     │
  │  .write() / .read()         │
  └──────────────┬──────────────┘
                 │
     ┌───────────┴───────────┐
     ▼                       ▼
  iOS                       Android
  ┌─────────────────┐       ┌─────────────────┐
  │ Keychain         │       │ Keystore +      │
  │ (шифрование ОС)  │       │ шифрование      │
  └─────────────────┘       └─────────────────┘
```

### Источники

- [flutter_secure_storage (pub.dev)](https://pub.dev/packages/flutter_secure_storage)
- [iOS: Keychain Services](https://developer.apple.com/documentation/security/keychain_services)
- [Android: Keystore system](https://developer.android.com/training/articles/keystore)

---

## Обмен кредами между приложениями

### Зачем обмениваться кредами?

- **Основное приложение** и **расширение** (виджет, Share Extension, Watch App) часто должны использовать **одни и те же** токены/состояние входа.
- Пользователь логинится в основном приложении — виджет или расширение должны показывать контент **без повторного входа**.

### Сценарии

| Сценарий | Пример |
|----------|--------|
| Приложение + виджет | Виджет показывает данные залогиненного пользователя |
| Приложение + Share Extension | Расширение проверяет токен и отправляет от имени пользователя |
| Приложение + Watch App | Часы и телефон — один аккаунт, общие токены |
| Несколько приложений одного вендора | Общая App Group и Keychain group |

### iOS: App Groups

- **App Groups** — механизм iOS, позволяющий нескольким целям (приложение + расширения) иметь общий доступ к:
  - **общему контейнеру** (файлы, UserDefaults с общим suite name);
  - **общей группе доступа в Keychain** (kSecAttrAccessGroup).
- Без App Group у каждого target своя песочница и свой Keychain.

**Настройка:**

1. Xcode → target → **Signing & Capabilities** → **+ Capability** → **App Groups**.
2. Добавьте группу (например `group.com.yourcompany.yourapp`).
3. Тот же идентификатор добавьте в каждый target расширения.

```
  Основное приложение          Расширение (виджет)
  ┌─────────────────┐          ┌─────────────────┐
  │ Keychain        │          │ Keychain        │
  │ access group:   │  ◄────►  │ access group:   │
  │ group.com.xxx   │   общий  │ group.com.xxx   │
  └─────────────────┘          └─────────────────┘
```

### Android: отличия

- На Android **нет аналога App Groups**. Виджет обычно живёт в процессе основного приложения.
- Данные и креды хранятся в одном приложении; виджет читает их через общий процесс или через сервисы/ContentProvider.
- Два отдельных приложения делят креды через **облако** или **AccountManager**.

### Сравнение

| Аспект | iOS | Android |
|--------|-----|---------|
| Общий доступ к кредам | App Groups + Keychain access group | Нет общего Keychain; виджет в рамках одного приложения |
| Настройка | Capability App Groups, один group id | Общая кодовая база/процесс или передача данных |

### Источники

- [Apple: App Groups](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups)
- [Apple: Keychain Sharing](https://developer.apple.com/documentation/security/keychain_services/keychain_items/sharing_access_to_keychain_items_among_a_collection_of_apps)
- [Android: App widgets](https://developer.android.com/guide/topics/appwidgets)

---

## Что такое Keychain?

- **Keychain** — системное хранилище Apple для **паролей, ключей и сертификатов**.
- Данные **шифруются ОС** и привязаны к приложению (или к группе приложений через App Group). Другие приложения по умолчанию к ним не имеют доступа.
- Используется для токенов, паролей, PIN, ключей API — то, что не должно храниться в открытом виде в файлах приложения. Во Flutter доступ к Keychain даёт пакет **flutter_secure_storage**.
