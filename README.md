# LOLify
<center>
  <img src="./assets/logo.png" alt="Логотип приложения" />
</center>

## Описание приложения
LOLify — это развлекательное приложение для поиска и обмена мемами. Пользователи могут искать мемы на разные темы, сохранять их и делиться ими в Интернете.

## Функции приложения
**Backlog**:
- поиск мемов по фильтрам;
- добавление мема в избранное;
- скачивание мема на телефон;
- обмен мемом в соцсетях;
- генерация нового мема;
- удаление мема из избранного;
- смена цветовой темы.

## Структура базы данных
![База данных](./assets/models/db.png)
Таблица `memes` содержит три столбца:
- `id_meme` (основной ключ, автоинкремент);
- `desc` (уникальное описание, не NULL);
- `url` (уникальный URL, не NULL).

## Навигация приложения
![Навигация](./assets/models/nav.png)

Навигация внутри приложения LOLify выглядит следующим образом:
- **Intro Page** (Стартовая страница) ведет к **Meme Page** (странице мемов);
- С **Meme Page** можно перейти на **Generate Page** (страницу генерации мемов), **Favourite Page** (страницу избранных мемов) и **Settings Page** (страницу настроек);
- Страницы **Generate Page**, **Favourite Page** и **Settings Page** имеют связи с **Meme Page**, позволяя переходить туда для дальнейших действий.

## Архитектура приложения
![Архитектура](./assets/models/arch.png)

Архитектура приложения состоит из трёх основных компонентов:
1. **UI** — фронтенд, построенный на Flutter, который отвечает за отображение экранов и взаимодействие с пользователем;
2. **Logic** — представлена использованием Provider для управления состоянием и бизнес-логикой;
3. **Networking** — здесь используются [Humor API](https://humorapi.com/) для получения данных с внешнего сервера и SQLite DB для хранения данных локально на устройстве.

UI взаимодействует с логикой через Provider, а логика обрабатывает запросы к API и базе данных.

## Стек разработки
Стек приложения включает следующие компоненты:
* **API (Humor API)**: Для получения юмористического контента из внешнего источника;
* **Local Storage (SQFlite/SharedPreferences)**: Для хранения данных локально, например, мемов или настроек;
* **State Managment (Provider)**: Для управления состоянием приложения и связи с UI;
* **Navigation (namedRoute)**: Для управления навигацией между экранами приложения;
* **Native API (permission_handler)**: Для получения разрешений от устройства пользователя.

## Обзор приложения
### Вступительная заставка

При первом запуске приложения открывается заставка приложения. При последующих запусках
приложения заставка больше не появляется.

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/intro_1.jpg" alt="Логотип 1" />
  </div>
  <div>
    <img src="./assets/screenshots/intro_2.jpg" alt="Логотип 2" />
  </div>
  <div>
    <img src="./assets/screenshots/intro_3.jpg" alt="Логотип 3" />
  </div>
  <div>
    <img src="./assets/screenshots/intro_4.jpg" alt="Логотип 3" />
  </div>
</div>

### Цветовая тема

Пользователь может выбрать приложение в светлой или темной теме. Последняя установленная
пользователем тема приложения сохраняется при последующих запусках.

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/light_1.jpg" alt="Логотип 1" />
  </div>
  <div>
    <img src="./assets/screenshots/light_2.jpg" alt="Логотип 2" />
  </div>
  <div>
    <img src="./assets/screenshots/light_3.jpg" alt="Логотип 3" />
  </div>
  <div>
    <img src="./assets/screenshots/light_4.jpg" alt="Логотип 3" />
  </div>
</div>

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/dark_1.jpg" alt="Логотип 1" />
  </div>
  <div>
    <img src="./assets/screenshots/dark_2.jpg" alt="Логотип 2" />
  </div>
  <div>
    <img src="./assets/screenshots/dark_3.jpg" alt="Логотип 3" />
  </div>
  <div>
    <img src="./assets/screenshots/dark_4.jpg" alt="Логотип 3" />
  </div>
</div>

### Поиск мемов

На странице поиска пользователь может выбрать поиск мемов по ключевым словам и количеству мемов.
Мемы оформлены в виде списка из карточек с описанием и изображением мема. С каждым мемом есть три
действия: добавить мем в избранное, скачать мем на телефон, поделиться мемом в Интернете.

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/search_1.jpg" alt="Логотип 1" />
  </div>
  <div>
    <img src="./assets/screenshots/search_2.jpg" alt="Логотип 2" />
  </div>
  <div>
    <img src="./assets/screenshots/search_3.jpg" alt="Логотип 3" />
  </div>
    <div>
    <img src="./assets/screenshots/search_4.jpg" alt="Логотип 1" />
  </div>
</div>

<div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/search_5.jpg" alt="Логотип 2" />
  </div>
  <div>
    <img src="./assets/screenshots/search_6.jpg" alt="Логотип 3" />
  </div>
    <div>
    <img src="./assets/screenshots/search_9.jpg" alt="Логотип 1" />
  </div>
  <div>
    <img src="./assets/screenshots/search_7.jpg" alt="Логотип 2" />
  </div>
</div>

### Генерация мема

На странице генерации пользователь получает рандомный мем. Совокупные действия с мемом такие же,
что и на странице поиска.

<div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/generate_1.jpg" alt="Логотип 2" />
  </div>
  <div>
    <img src="./assets/screenshots/generate_2.jpg" alt="Логотип 3" />
  </div>
    <div>
    <img src="./assets/screenshots/generate_4.jpg" alt="Логотип 1" />
  </div>
</div>

<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/generate_3.jpg" alt="Логотип 2" />
  </div>
  <div>
    <img src="./assets/screenshots/generate_5.jpg" alt="Логотип 3" />
  </div>
</div>

### Избранное

На странице избранного пользователь может видеть добавленные мемы. Выбранный мем может удалить. (скачать или поделиться также есть)

<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/favourite_1.jpg" alt="Логотип 2" />
  </div>
    <div>
    <img src="./assets/screenshots/favourite_3.jpg" alt="Логотип 1" />
  </div>
</div>

### Адаптивный дизайн

Когда приложение находится в горизонтальной ориентации, то список карточек мемов преобразуется в сетку по две колонки. (в случае ширины экрана больше, чем 600 пикселей)

<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px;">
  <div>
    <img src="./assets/screenshots/adaptive_search_1.jpg" alt="Логотип 1" />
  </div>
  <div>
    <img src="./assets/screenshots/adaptive_search_3.jpg" alt="Логотип 2" />
  </div>
</div>
