class TurkeyLocationService
  def self.provinces
    TURKEY_PROVINCES_DATA.keys
  end

  def self.districts_for(il)
    TURKEY_PROVINCES_DATA[il]
  end

  def self.match(address_line)
    return nil if address_line.blank?

    normalized = normalize(address_line)

    # Önce doğrudan il adı geçiyor mu diye bak (en güvenilir eşleşme)
    direct_il = TURKEY_PROVINCES_DATA.keys.find { |il| normalized.include?(normalize(il)) }
    return { il: direct_il, ilce: nil } if direct_il

    # İl adı yoksa, ilçe adından ile geri dönmeyi dene
    TURKEY_PROVINCES_DATA.each do |il, ilceler|
      eslesen_ilce = ilceler.find { |ilce| normalized.include?(normalize(ilce)) }
      return { il: il, ilce: eslesen_ilce } if eslesen_ilce
    end

    nil
  end

  # Verilen ilin sınırları içinde, metinde geçen bir ilçe adı arar (başka illerin
  # ilçeleriyle yanlışlıkla eşleşmesini önlemek için aramayı o ile sınırlar)
  def self.district_within(il, address_line)
    return nil if address_line.blank? || il.blank?

    ilceler = TURKEY_PROVINCES_DATA[il] || []
    normalized = normalize(address_line)
    ilceler.find { |ilce| normalized.include?(normalize(ilce)) }
  end

  # Karşılaştırma için normalize eder. OCM verisinde bazı kayıtlar Türkçe karakterleri
  # düzgün kullanıyor ("İstanbul", "Kütahya"), bazıları Türkçe klavyesi olmayan biri
  # tarafından ASCII karşılıklarıyla girilmiş ("Istanbul", "Kutahya") - ikisinin de
  # AYNI yer olarak eşleşmesi için tüm Türkçe özel harfleri ASCII karşılıklarına
  # indirgeyip öyle karşılaştırıyoruz.
  TURKISH_CHAR_MAP = { "İ" => "i", "I" => "i", "ı" => "i", "Ü" => "u", "ü" => "u",
                        "Ö" => "o", "ö" => "o", "Ç" => "c", "ç" => "c",
                        "Ş" => "s", "ş" => "s", "Ğ" => "g", "ğ" => "g" }.freeze

  def self.normalize(text)
    text.to_s.strip.gsub(/[İIıÜüÖöÇçŞşĞğ]/) { |ch| TURKISH_CHAR_MAP[ch] }.downcase
  end

  # OCM verisinde StateOrProvince alanı çoğu zaman boş veya tutarsız yazılmış oluyor,
  # Town alanına da sıklıkla ilçe yerine il adının kendisi giriliyor ("Town: İstanbul").
  # Adres bilgisinden il/ilçe çıkararak bu alanları normalize/backfill eder.
  def self.normalize_addresses!(stations)
    return stations if stations.blank?

    province_names = provinces.map { |il| normalize(il) }

    stations.each do |station|
      info = station["AddressInfo"]
      next unless info

      combined = [ info["AddressLine1"], info["Town"], info["StateOrProvince"] ].join(" ")
      matched = match(combined)
      next unless matched

      info["StateOrProvince"] = matched[:il]

      town_looks_like_a_province = province_names.include?(normalize(info["Town"]))
      if info["Town"].blank? || town_looks_like_a_province
        info["Town"] = district_within(matched[:il], info["AddressLine1"])
      end
    end
    stations
  end
end
