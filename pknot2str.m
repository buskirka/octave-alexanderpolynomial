function rstr = pknot2str ( in_knot )
    % Extracts diagram structure from a polygonal knot.
    if( length(size(in_knot)) ~= 2 )
        error("Object specified cannot specify a knot.");
    endif
    if( size(in_knot,1) ~= 3)
        error("Provided matrix does not specify a 3-dimensional knot. (it's not 3xN)");
    endif
    
    knot=in_knot;

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

            solnpt=[proj_x-proj_y,proj_z-proj_w]\(proj_x-proj_w)
            if( 
        endfor
    endfor
endfunction
