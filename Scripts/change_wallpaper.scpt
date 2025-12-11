-- change_wallpaper.scpt (HATASIZ RASTGELE SEÇİM İLE GÜNCELLENDİ)
-- Bu script, belirtilen klasördeki ve TÜM ALT KLASÖRLERDEKİ tüm görselleri bulup rastgele birini seçer.

-- **DÜZENLE: Wallpapers klasörünüzün tam yolunu buraya girin.**
set main_folder_path to "/Users/aliemreaydin/Wallpapers/" -- BURAYI KENDİ YOLUNUZLA DEĞİŞTİRİN!

-- AppleScript'in POSIX yolu ile çalışabilmesi için alias oluşturma
set main_folder to POSIX file main_folder_path as alias

-- Tüm görselleri tutacak liste
set all_image_files to {}

tell application "Finder"
    -- Alt klasörlerin içindeki tüm dosyaları özyinelemeli olarak bulur
    set all_items to entire contents of main_folder as alias list
    
    repeat with an_item in all_items
        -- Sadece dosya uzantılarına göre görsel dosyalarını filtreler
        try
            set item_info to info for an_item
            
            -- yaygın görsel uzantıları kontrolü
            set item_name to name of an_item
            if item_name ends with ".jpg" or item_name ends with ".jpeg" or item_name ends with ".png" or item_name ends with ".tiff" or item_name ends with ".webp" then
                copy an_item to end of all_image_files
            end if
        on error
            -- Hata veren veya klasör olan öğeleri atla
        end try
    end repeat
    
    -- Eğer hiç görsel bulunamazsa
    if all_image_files is {} then
        display notification "Duvar kağıdı klasöründe hiç görsel bulunamadı!" with title "Wallpapers Script"
        return
    end if
    
    -- Rastgele bir dosya seçimi: Hata veren kısmı bununla değiştiriyoruz.
    
    -- Toplam dosya sayısını al
    set file_count to count of all_image_files
    
    -- 1 ile dosya sayısı arasında rastgele bir tam sayı üret
    set random_index to (random number from 1 to file_count)
    
    -- Seçilen dosyayı listeden al
    set chosen_file to item random_index of all_image_files
    
    -- Seçilen dosyanın POSIX yolunu al
    set chosen_file_path to POSIX path of chosen_file
end tell

-- System Events uygulamasına duvar kağıdını değiştirmesi için komut ver
tell application "System Events"
    tell current desktop
        set picture to chosen_file_path
    end tell
end tell
