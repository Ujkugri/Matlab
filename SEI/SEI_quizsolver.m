classdef SEI_quizsolver < handle
    %%  Properties of object are created
    properties
        start
        obstacles
        letters
        letter_array
        letter_bin
        borders
        collection
        x,y
    end
    %%  Methods  
    methods
        %%  __init__: Properties of object are initialized together with
        function self = SEI_quizsolver(s,o,l)
            %    Start position
            self.start = s;
           
            %    Container for the obstacles
            self.obstacles = o;
           
            %    Container for the letters 
            self.letters = l;
            self.letter_array = cell2mat(cellfun(@(x)(self.letters.(x)),...
                                               fieldnames(self.letters),...
                                               'UniformOutput',false));
            self.letter_bin;
           
            %    Borders are created
            self.borders = [];
            for i = 1:7
                self.borders = [self.borders; [0,i]];    % left border
                self.borders = [self.borders; [8,i]];    % right border
                self.borders = [self.borders; [i,0]];    % top border
                self.borders = [self.borders; [i,8]];    % bottom border
            end
            %    Container for already visited positions within the maze
            self.collection = [0 0];
        end
        %%   Additional methods
        %    Method for checking if object is encountering an obstacle
        function is_in = isObstacle(self,array)
            if logical(sum((self.obstacles(:,1)== array(1) &...
                            self.obstacles(:,2) == array(2))))
                is_in = true;
            else
                is_in = false;
            end
        end
       
        %    Method for checking if object has already visited a certain
        %    position
        function is_in = isVisited(self,array)
            if logical(sum((self.collection(:,1)== array(1) &...
                            self.collection(:,2) == array(2))))
                is_in = true;
            else
                is_in = false;
            end
        end
       
        %    Method for checking if object is outside the maze
        function is_in = isOutside(self,array)
            if logical(sum((self.borders(:,1)== array(1) &...
                            self.borders(:,2) == array(2))))
                is_in = true;
            else
                is_in = false;
            end
        end
       
        %    Method for checking if current position has one of the letters
        function is_in = isLetter(self,array)
            if logical(sum((self.letter_array(:,1)== array(1) &...
                            self.letter_array(:,2) == array(2))))
                is_in = true;
            else
                is_in = false;
            end
        end
       
        %    Method for moving the object
        function move(self,horizontal,vertical)
            self.x = horizontal;
            self.y = vertical;
        end
       
        %    Method for retrieving letters
        function let = getLetter(self,array)
            fieldNames = fieldnames(self.letters);
            for i = 1:numel(fieldnames(self.letters))
                if isequal(self.letters.(fieldNames{i}), array)
                    let = fieldNames{i};
                else
                    continue
                end
            end
        end
       
        %    Method for the algorithm
        function moveIter(self,horizontal,vertical)
            move(self,horizontal,vertical)
           
            %    Check if position is valid or not
            if isObstacle(self,[horizontal vertical])|| ...
               isOutside(self,[horizontal vertical]) || ...
               isVisited(self,[horizontal vertical])
                return
            end
           
            %    Check if position has letter and collect it if true
            if isLetter(self,[horizontal vertical])
                self.letter_bin = [self.letter_bin;...
                                   getLetter(self,[horizontal vertical])];
            end
           
            %    Append position to already visited positions
            self.collection = [self.collection;[horizontal vertical]];
           
            %    The actual algorithm
            moveIter(self,horizontal+1,vertical)           % go to right
            moveIter(self,horizontal,vertical+1)           % go to down
            moveIter(self,horizontal-1,vertical)           % go to left
            moveIter(self,horizontal,vertical-1)           % go to up           
        end
    end
end