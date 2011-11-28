classdef SparseMatrix
    % class to hold sparse matrix in 3 column format, including automatic
    %   resizing functions
    
    properties % ===============================================================
        index = 0;      % pointer to the last item in the sparse matrix
        matrix = zeros(30,3);% initial size for sparse matrix
    end

    properties (Dependent = true)
        mem;            % total number of rows (i.e. a measure of how much
                        %   memory is being used
        maxdims;        % maximum indices in each dimension
    end
    
    methods % ==================================================================
        function mem = get.mem(obj)
            mem = size(obj.matrix,1);
        end
        
        function maxdims = get.maxdims(obj)
            temp = max(obj.matrix);
            maxdims = temp(1:2);
        end
        
        function obj = extend(obj,extraLength)
            % extends the storage by doubling the length until there are
            %   extraLength free spaces
            obj = obj.compress;
            
            while (obj.mem - obj.index) < extraLength
                obj.matrix(2*obj.mem,3) = 0;
            end
        end
        
        function obj = compress(obj)
            % compresses the matrix - sums up all repeated terms, and eliminates all zeros
            if sum(obj.matrix(:,1)) ~= 0
                consolidatedMatrix = sparse(obj.matrix(1:(obj.index),1),obj.matrix(1:(obj.index),2),obj.matrix(1:(obj.index),3));
                [temp(:,1),temp(:,2),temp(:,3)] = find(consolidatedMatrix);
                obj.matrix = temp;
                clear consolidatedMatrix;
                obj.index = size(obj.matrix,1);
            end
        end
        
        function matlabSparse = toSparse(obj,varargin)
            % returns a real Matlab sparse matrix - optionally specify dimensions with varargin
            optargin = size(varargin,2);
            if optargin == 0
                matlabSparse = sparse(obj.matrix(1:(obj.index),1),obj.matrix(1:(obj.index),2),obj.matrix(1:(obj.index),3));
            elseif optargin == 1
                m = cell2mat(varargin);
                matlabSparse = sparse(obj.matrix(1:(obj.index),1),obj.matrix(1:(obj.index),2),obj.matrix(1:(obj.index),3),m,m);
            elseif optargin == 2
                m = varargin{1};
                n = varargin{2};
                matlabSparse = sparse(obj.matrix(1:(obj.index),1),obj.matrix(1:(obj.index),2),obj.matrix(1:(obj.index),3),m,n);
            end
        end
        
        function obj = append(obj,appendingMatrix,varargin)
            optargin = size(varargin,2);
            if optargin == 0
                error('SparseMatrix.append requires matrix indices to be specified');
            elseif optargin == 1
                iindex = cell2mat(varargin);
                jindex = iindex;
                if size(appendingMatrix,1) ~= size(appendingMatrix,2)
                    error('Two sets of matrix indices meed to be specified when appending a non-square matrix');
                elseif length(iindex) ~= size(appendingMatrix,1)
                    error('Specified indices and size of matrix to be appended are different sizes');
                end
            elseif optargin == 2
                iindex = varargin{1};
                jindex = varargin{2};
                if (length(iindex) ~= size(appendingMatrix,1)) || (length(jindex) ~= size(appendingMatrix,2))
                    error('Specified indices and size of matrix to be appended are different sizes');
                end
            end
            
            % find the nonzero values and their indices
            [i j v] = find(appendingMatrix);
            % convert the indices to global coordinates
            i = iindex(i)';
            j = jindex(j)';
            if size(j,1) == 1
                j = j';
            end
            
            % extend the matrix if necessary
            if (obj.mem - obj.index) < length(v)
                obj = obj.extend(length(v));
            end
            
            % append the data
            obj.matrix((obj.index+1):obj.index+length(v),:) = [i j v];
            
            % update the pointer
            obj.index = obj.index + length(v);
        end
        
        function obj = diet(obj)
            % slices off extra zeros
            obj.matrix = obj.matrix(1:obj.index,:);
        end
        
    end
    
end