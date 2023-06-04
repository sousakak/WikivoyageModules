local p = {}

function hslToRgb(h, s, l)
	-- h is a frequency system, and s and l are percentages
	h = h / 360
	s = s / 100
	l = l / 100
	r, g, b;

	if s == 0 then return l * 255, l * 255, l * 255 end
	local function hue2rgb(p, q, t)
		if t < 0 then
			t = t + 1
		elseif t > 1 then
			t = t - 1
		elseif t < 1 / 6 then
			return p + (q - p) * 6 * t
		elseif t < 1 / 2 then
			return q
		elseif t < 2 / 3 then
			return p + (q - p) * (2 / 3 - t) * 6
		else
			return p
		end
	end

	local q = l < 0.5 and l * (1 + s) or l + s - l * s
	local p = 2 * l - q
	r = hue2rgb(p, q, h + 1 / 3)
	g = hue2rgb(p, q, h)
	b = hue2rgb(p, q, h - 1 / 3)

	return r * 255, g * 255, b * 255
end

function p.getColor(qty)
	local colors = {
        --[[
            colors = { {r, g, b}, {r, g, b}, {r, g, b}, ..., {r, g, b} }
            The unit {r, g, b} is not an associative array, but a normal table
        ]]
    }
	local unit = 360 / qty

	if qty < 24 then
		local light = 50
    else
        local lightUnit = 100 / (qty / 12 + 1)
    end
    local i = 0
    while i ~= qty do
        i = i + 1
        local lightness = light or lightUnit * i
        r, g, b = hslToRgb(unit * i, 50, lightness)
        table.insert(colors, {r, g, b})
    end

    return colors
end

return p