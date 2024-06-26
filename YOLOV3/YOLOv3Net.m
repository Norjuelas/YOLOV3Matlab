%% Script to create a classs YOLO

classdef YOLOv3Net

    properties
        Name
        Anchor
        DataStore
        Detector
        LGraph
    end

    methods
        function obj = YOLOv3Net(name)
            obj.Name=name;
            disp("Creaded Neural Network // Red Neuronal creada:" + name);
        end
    
        function obj = set.DataStore(obj,ds)
            obj.DataStore = ds;
            disp(obj)
        end
        
        function obj = set.LGraph(obj,ds)
            obj.LGraph = ds;
        end      
        
        function [lgraph , obj] = createLayers(obj)
            addpath('YOLO_robocup/utilities');

            disp("Creating layers... / creando capas...");
            layer = createLayers();
            
            lgraph = layerGraph(layer);
            disp("Layer Graph Created! / grafico de capas creado ");

            Anchors = [41, 116; 67,37; 49, 49; 53, 53];
            lgraph = yolov3Layers([270, 270, 3], 2, Anchors, lgraph, 'relu_4');  
            obj.LGraph = lgraph;
        end

        %% Train the NN from DATA store / entrenar NN desde la Data store
        function obj = train(obj)

            lgraph = obj.LGraph;
            options = trainingOptions('adam',...
                "InitialLearnRate", 0.0001 ,...
                "Verbose", true,...
                "MiniBatchSize", 30, "MaxEpochs",100, ...
                'Shuffle',"every-epoch", "VerboseFrequency",30);            
            
            ds = obj.DataStore; 
            [detectorYolo2, info] = trainYOLOv2ObjectDetector(ds, lgraph, options); 
            
            obj.Detector = yolov3ObjectDetector;
        
        end

        function [img, bboxes, scores, labels] = predict(obj, image)
           img = imresize(image, [270,270]); % Resize (Encode) 
           [bboxes, scores, labels] = detect(obj.Detector, img); 

            if(~isempty(bboxes))
                img = insertObjectAnnotation(img,'rectangle',bboxes,labels);
            end

            imshow(img)
        end
    end 
end


