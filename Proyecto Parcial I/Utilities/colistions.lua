local M = {}

function M.getRectVertices(rect)
    local vertices = {
        {rect.x, rect.y},                               -- Esquina superior izquierda
        {rect.x + rect.width, rect.y},                  -- Esquina superior derecha
        {rect.x + rect.width, rect.y + rect.height},    -- Esquina inferior derecha
        {rect.x, rect.y + rect.height}                  -- Esquina inferior izquierda
    }
    return vertices
end

function M.pointInPolygon(x_punto, y_punto, vertices)

    local num_vertices  = #vertices -- 4 Vertices Ingresados
    local cnt = 0
    
    for i = 1, num_vertices do
        local x1, y1 = vertices[i][1], vertices[i][2]
        local x2, y2 = vertices[(i % num_vertices) + 1][1], vertices[(i % num_vertices) + 1][2]

        if ((y1 > y_punto) ~= (y2 > y_punto)) and (x_punto < (x2 - x1) * (y_punto - y1) / (y2 - y1) + x1) then
            cnt = cnt + 1
        end
    end

    return cnt % 2 == 1
end

function M.pointInTriangle(A, B, C, P)
    local s1 = C[2] - A[2]
    local s2 = C[1] - A[1]
    local s3 = B[2] - A[2]
    local s4 = P[2] - A[2]

    local w1 = (A[1] * s1 + s4 * s2 - P[1] * s1) / (s3 * s2 - (B[1] - A[1]) * s1)
    local w2 = (s4 - w1 * s3) / s1

    return w1 >= 0 and w2 >= 0 and (w1 + w2) <= 1
end


function M.inCircunference(x, y, x_centro, y_centro, radio)
    local distancia = math.sqrt((x - x_centro)^2 + (y - y_centro)^2) -- Distancia entre el punto y el centro
    return distancia <= radio -- Revisa si el punto no sobrepasa el radio
end

function M.getCircleValues(circulo, radio)
    local cX = circulo.x + radio
    local cY = circulo.y + radio
    local resultado = {cX, cY}
    return resultado
end

return M
