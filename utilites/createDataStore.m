function [dataStore] = createDataStore()
    dataStore = imageDatastore('data/imgs', 'FileExtensions', [".jpg", ".png"]);
end

