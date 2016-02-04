function rstr = pknot2str ( in_knot )
    % Extracts diagram structure from a polygonal knot.
    if( length(size(in_knot)) ~= 2 )
        error("Object specified cannot specify a knot.");
    endif
    if( size(in_knot,1) ~= 3)
        error("Provided matrix does not specify a 3-dimensional knot. (it's not 3xN)");
    endif
    
    knot=in_knot;
    
    intersections=shift(eye(size(knot,2)),1)
    % Find intersections of sections
    %  First, select each segment
    for n=1:size(knot,2)
        % Find the starting and ending vertices:
        edge_x=knot(:,n) ;
        edge_y=knot(:,mod(n,size(knot,2)-1)+1) ;
        % Selection of m_max prevents computation of adjacent edges
        % (whose intersections do not matter).
        if( n==1 )
            m_max=size(knot,2)-1;
        else
            m_max=size(knot,2);
        endif
        % Compare to each nonadjacent segment and attempt to find intersections:
        for m=(n+2):m_max
            edge_w=knot(:,m) ;
            edge_z=knot(:,mod(m,size(knot,2))+1) ;
            
            printf([num2str(n),' to ',num2str(m),':\n']);
            % Determine whether the projections 
            % of xy and wz intersect, using matrices.
            % First, project x, y, w, and z onto R^2.
            proj_x = edge_x([1,2]);
            proj_y = edge_y([1,2]);
            proj_w = edge_w([1,2]);
            proj_z = edge_z([1,2]);

            % Calculate where the intersection of these two lines
            % occurs; such that the point of overlap is
            % p = (y-x)*solnpt(1) + x = (z-w)*solnpt(2) + w
            solnpt=[proj_x-proj_y,proj_z-proj_w]\(proj_x-proj_w)
            if( 0 < min(solnpt) && max(solnpt) < 1 )
                % In this case, where both coordinates are between
                % 0 and 1, we know that an intersection of the two
                % *line segments* (not just the lines) has occured.
                printf(['Intersection on ', ...
                        num2str(n), ...
                        ' to ', ...
                        num2str(m), ...
                        ' found.\n']);
                intersections(n,m)=solnpt(1);
                intersections(m,n)=solnpt(2);
                intersections
            elseif( any(solnpt == 0) || any(solnpt == 1) )
                % If any of this occurs, some endpoint of the polygonal curve 
                % must have ended up on an edge; i.e. projection down the 
                % third coordinate is invalid.
                error(['A vertex has been projected onto the endpoint of ',...
                       'another edge; the projection is invalid. ',...
                       'Try "tilting" the knot slightly with a 3-d ',...
                       'isometry, or double check to ensure that ',...
                       'intersections are not happening already in ',...
                       'the knot itself.']);
            endif
        endfor
    endfor
endfunction
