# Стиль карт Ingreelab для [Guru Maps](https://gurumaps.app)

Стиль для `Guru Maps` вдохновлённый рендером `Ingreelab.net` для OSM карт, созданный для улучшения читаемости карт.

[in English](README.md)

![Example of rendering](screenshot.jpg)


## Основные особенности

* Увеличивает количество отображаемых объектов на более общих картах, в зависимости от доступности данных и здравого смысла.
* Улучшает видимость и читаемость основных дорог, трасс, ж/д путей.
* Добавляет контраст в отображение лесных дорог, путей и т.п., что очень полезно для пеших маршрутов и оффроуда.


## Как установить

[Нажмите на эту ссылку на вашем телефоне/планшете](guru://open/?url=https://github.com/zebooka/gurumaps-style-ingreelab/releases/download/v2.2.0/Ingreelab-v2.2.0.zip)

ИЛИ

Чтобы добавить вручную этот стиль в приложение, скачайте `Release (zip)` из списка файлов и сохрание его в папку приложения `Guru Maps`.
- Android: `/Android/data/com.bodunov.galileo/` или `Android/data/com.bodunov.GalileoPro/files`
- iOS: `Приложение Файлы` → `Guru Maps` или с компьютера `Места`/`iTunes` → `Имя вашего устройства` → `Файлы` → `Guru Maps` или `Guru Maps Pro`
- macOS: `~/Library/Containers/com.bodunov.galileo/Data/Documents/`.

Затем, используя файловый менеджер распакуйте архив, перезапустите `Guru Maps` и новый стиль появится в списке оффлайн карт с именем `Ingreelab HD vX.Y.Z`.


### Небольшая пометка

Для того, чтобы появилась папка приложения, вам может понадобиться вначале создать точку или записать трек. Некоторые версии Android не позволяют писать в папки приложений. Для установки стиля вам может понадобится компьютер.


## Почему стиль называется *Ingreelab HD*?

**Ingreelab** потому что он повторяет растровый стиль отрисовки OSM карт с сайта `Ingreelab.net`. **HD** потому что это стиль с высокой плотностью отображения объектов на карте и ради возможных будущих версий с меньшей плотностью. Версия HD разрабатывалась на основе Сибирского региона России, где не так много основных дорог.


## Ссылки

* Проект: https://github.com/zebooka/gurumaps-style-ingreelab

* iOS: https://apps.apple.com/us/app/guru-maps/id321745474
* Android: https://play.google.com/store/apps/details?id=com.bodunov.galileo

* Базовый стиль: https://github.com/GuruMaps/MapStyle
* MapCSS: https://gurumaps.app/manuals/ios/06-mapcss.html


## Авторы

Основан на [базовом стиле](https://github.com/GuruMaps/MapStyle) от команды Guru Maps. В базовом стиле не указана лицензия,
поэтому вы можете считать, что данный стиль распространяется под лицензией MIT.

* Evgen Bodunov
* Anton Bondar https://zebooka.com
