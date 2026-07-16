# ⚡ Şarj Haritası

Türkiye genelindeki elektrikli araç (EV) şarj istasyonlarını tek bir platformda gösteren, [Open Charge Map API](https://openchargemap.org/) verilerini kullanan bir Ruby on Rails web uygulaması.

## 📍 Vizyonumuz

Türkiye genelindeki tüm elektrikli araç şarj istasyonlarını tek bir platformda birleştiren, sürücülerin yolculuklarını kesintisiz ve güvenle planlamasını sağlayan lider şarj istasyonu haritası olmak.

## ⚡️ Misyonumuz

EV sürücülerine en güncel, doğru ve anlık istasyon bilgilerini sunarak şarj noktası bulmayı kolaylaştırmak; Türkiye'nin elektrikli araç dönüşümüne ve sürdürülebilir geleceğe hızlı, pratik çözümlerle katkıda bulunmak.

## 🛠 Kullanılan Teknolojiler

- **Ruby** 3.3.7
- **Rails** 8.1.3
- **Stimulus** — interaktif bileşenler için (toggle, map-toggle controller'ları)
- **Leaflet.js** — harita görselleştirme
- **Open Charge Map API** — şarj istasyonu verileri
- **Bootstrap 5.3** — grid sistemi, navbar, card bileşenleri
- **Importmap** — JavaScript bağımlılık yönetimi

## ✨ Özellikler

- Türkiye genelindeki şarj istasyonlarının harita üzerinde gösterimi
- Mesafeye göre dinamik filtreleme (slider ile)
- Responsive navbar (hamburger menü ile mobil uyumluluk)
- İstasyon arama ve detay görüntüleme

## 🚀 Kurulum

### Gereksinimler

- Ruby 3.3.7
- Rails 8.1.3
- Bundler
- Bir [Open Charge Map API](https://openchargemap.org/site/develop/api) anahtarı

### Adımlar

1. Depoyu klonlayın:

   ```bash
   git clone <repo-url>
   cd sarj-haritasi
   ```

2. Gerekli gem'leri yükleyin:

   ```bash
   bundle install
   ```

3. Ortam değişkenlerini ayarlayın. Proje kök dizininde bir `.env` dosyası oluşturun (veya Rails credentials kullanıyorsanız `rails credentials:edit` ile ekleyin):

   ```
   OPEN_CHARGE_MAP_API_KEY=buraya_api_anahtarinizi_yazin
   ```

4. Veritabanını hazırlayın:

   ```bash
   rails db:create
   rails db:migrate
   ```

   (Varsa örnek verilerle başlamak için: `rails db:seed`)

5. JavaScript bağımlılıklarının (Bootstrap, Stimulus) importmap üzerinden doğru yüklendiğini doğrulayın:

   ```bash
   bin/importmap json
   ```

6. Sunucuyu başlatın:

   ```bash
   bin/rails server
   ```

7. Tarayıcınızda açın:

   ```
   http://localhost:3000
   ```

## 📁 Proje Yapısı (özet)

```
app/
  controllers/       # Rails controller'ları
  javascript/
    controllers/      # Stimulus controller'ları (toggle, map-toggle vb.)
  views/
    home/              # Ana sayfa
    about/             # Hakkımızda sayfası
    stations/          # Şarj istasyonları sayfası
  assets/
    stylesheets/       # CSS (:root custom properties ile tema değişkenleri)
```

## 🔑 Open Charge Map API Anahtarı Alma

1. [openchargemap.org](https://openchargemap.org/site/develop/api) adresine gidin.
2. Ücretsiz bir hesap oluşturun.
3. API anahtarınızı alın ve yukarıdaki `.env` dosyasına ekleyin.

## 🙏 Teşekkür Ederiz

Yolculuğunuzda bizi tercih ettiğiniz ve haritamızı kullandığınız için teşekkür ederiz. Elektrikli araç deneyiminizi kolaylaştırmak için her zaman yanınızdayız.

---

© 2026 Şarj Haritası — Tüm Hakları Saklıdır.

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------ENGLISH---------------------------------------------------------------------------------------------------------------------------------------------------

# ⚡ Şarj Haritası (Charge Map)

A Ruby on Rails web application that displays electric vehicle (EV) charging stations across Turkey on an interactive map, powered by the [Open Charge Map API](https://openchargemap.org/).

## 📍 Our Vision

To become the leading charging station map by unifying all EV charging stations across Turkey on a single platform, enabling drivers to plan their journeys seamlessly and with confidence.

## ⚡️ Our Mission

To make finding charging points easier for EV drivers by providing the most up-to-date, accurate, and real-time station information — contributing to Turkey's EV transition with fast, practical solutions for a sustainable future.

## 🛠 Tech Stack

- **Ruby** 3.3.7
- **Rails** 8.1.3
- **Stimulus** — for interactive components (toggle, map-toggle controllers)
- **Leaflet.js** — map visualization
- **Open Charge Map API** — charging station data
- **Bootstrap 5.3** — grid system, navbar, card components
- **Importmap** — JavaScript dependency management

## ✨ Features

- Map view of charging stations across Turkey
- Dynamic distance-based filtering (via slider)
- Responsive navbar with hamburger menu for mobile
- Station search and detail view

## 🚀 Getting Started

### Prerequisites

- Ruby 3.3.7
- Rails 8.1.3
- Bundler
- An [Open Charge Map API](https://openchargemap.org/site/develop/api) key

### Setup

1. Clone the repository:

   ```bash
   git clone <repo-url>
   cd sarj-haritasi
   ```

2. Install the required gems:

   ```bash
   bundle install
   ```

3. Set up environment variables. Create a `.env` file in the project root (or use Rails credentials via `rails credentials:edit`):

   ```
   OPEN_CHARGE_MAP_API_KEY=your_api_key_here
   ```

4. Set up the database:

   ```bash
   rails db:create
   rails db:migrate
   ```

   (Run `rails db:seed` if sample data is available)

5. Verify JavaScript dependencies (Bootstrap, Stimulus) are correctly loaded via importmap:

   ```bash
   bin/importmap json
   ```

6. Start the server:

   ```bash
   bin/rails server
   ```

7. Open in your browser:

   ```
   http://localhost:3000
   ```

## 📁 Project Structure (overview)

```
app/
  controllers/       # Rails controllers
  javascript/
    controllers/      # Stimulus controllers (toggle, map-toggle, etc.)
  views/
    home/              # Home page
    about/             # About page
    stations/          # Charging stations page
  assets/
    stylesheets/       # CSS (theme variables via :root custom properties)
```

## 🔑 Getting an Open Charge Map API Key

1. Go to [openchargemap.org](https://openchargemap.org/site/develop/api).
2. Create a free account.
3. Get your API key and add it to the `.env` file above.

## 🙏 Thank You

Thank you for choosing us and using our map on your journey. We're always here to make your EV experience easier. Wishing you enjoyable and uninterrupted drives!

---

© 2026 Şarj Haritası — All Rights Reserved.