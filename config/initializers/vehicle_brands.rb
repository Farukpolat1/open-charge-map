raw_data = JSON.parse(File.read(Rails.root.join("config", "vehicle_brands.json")))
VEHICLE_BRANDS_DATA = raw_data["elektrikli_araclar"].map { |item| [ item["marka"], item ] }.to_h.freeze
