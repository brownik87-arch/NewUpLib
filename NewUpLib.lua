-- ══════════════════════════════════════════════════════════════
-- NewUp UI Library v14 | PREMIUM EDITION
-- by VordAudi · enhanced
-- ══════════════════════════════════════════════════════════════
local Library = {}
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local Players           = game:GetService("Players")

-- Чистим старые копии
for _, parent in ipairs({game:GetService("CoreGui"), Players.LocalPlayer:FindFirstChild("PlayerGui")}) do
    if parent then
        pcall(function()
            for _, n in ipairs({"NewUpLibrary","NewUpNotify"}) do
                local old = parent:FindFirstChild(n)
                if old then old:Destroy() end
            end
        end)
    end
end

local guiParent
pcall(function()
    local cg = game:GetService("CoreGui")
    local _ = cg:GetChildren()
    guiParent = cg
end)
if not guiParent then guiParent = Players.LocalPlayer:WaitForChild("PlayerGui") end

-- ══════════════════════════ ТЕМЫ ══════════════════════════
local Themes = {
    Tem1  = {name="Tem1 · Фиолет",  bg=Color3.fromRGB(18,18,24),  sidebar=Color3.fromRGB(14,14,19),  element=Color3.fromRGB(30,30,40),  elementHover=Color3.fromRGB(38,38,50),  accent=Color3.fromRGB(140,85,255),  text=Color3.fromRGB(238,238,245), subtext=Color3.fromRGB(135,135,155), stroke=Color3.fromRGB(42,42,55)},
    Tem2  = {name="Tem2 · Синий",   bg=Color3.fromRGB(16,18,26),  sidebar=Color3.fromRGB(12,14,20),  element=Color3.fromRGB(28,32,44),  elementHover=Color3.fromRGB(36,42,58),  accent=Color3.fromRGB(80,140,240),  text=Color3.fromRGB(232,238,248), subtext=Color3.fromRGB(130,140,165), stroke=Color3.fromRGB(40,46,62)},
    Tem3  = {name="Tem3 · Розовый", bg=Color3.fromRGB(22,16,22),  sidebar=Color3.fromRGB(16,12,16),  element=Color3.fromRGB(38,28,38),  elementHover=Color3.fromRGB(48,36,48),  accent=Color3.fromRGB(240,100,150), text=Color3.fromRGB(248,232,238), subtext=Color3.fromRGB(165,130,145), stroke=Color3.fromRGB(54,40,54)},
    Tem4  = {name="Tem4 · Зелёный", bg=Color3.fromRGB(16,22,18),  sidebar=Color3.fromRGB(12,16,13),  element=Color3.fromRGB(28,38,32),  elementHover=Color3.fromRGB(36,48,41),  accent=Color3.fromRGB(100,220,140), text=Color3.fromRGB(232,248,238), subtext=Color3.fromRGB(130,165,142), stroke=Color3.fromRGB(40,54,44)},
    Tem5  = {name="Tem5 · Красный", bg=Color3.fromRGB(22,16,18),  sidebar=Color3.fromRGB(16,12,13),  element=Color3.fromRGB(38,28,30),  elementHover=Color3.fromRGB(48,36,38),  accent=Color3.fromRGB(240,90,100),  text=Color3.fromRGB(248,232,234), subtext=Color3.fromRGB(165,130,132), stroke=Color3.fromRGB(54,40,42)},
    Tem6  = {name="Tem6 · Оранж",   bg=Color3.fromRGB(22,18,14),  sidebar=Color3.fromRGB(16,13,10),  element=Color3.fromRGB(38,32,26),  elementHover=Color3.fromRGB(48,41,33),  accent=Color3.fromRGB(255,150,60),  text=Color3.fromRGB(248,240,230), subtext=Color3.fromRGB(165,150,130), stroke=Color3.fromRGB(54,46,38)},
    Tem7  = {name="Tem7 · Бирюза",  bg=Color3.fromRGB(14,22,22),  sidebar=Color3.fromRGB(10,16,16),  element=Color3.fromRGB(24,38,38),  elementHover=Color3.fromRGB(32,48,48),  accent=Color3.fromRGB(60,220,200),  text=Color3.fromRGB(230,248,246), subtext=Color3.fromRGB(130,165,162), stroke=Color3.fromRGB(38,54,54)},
    Tem8  = {name="Tem8 · Золотой", bg=Color3.fromRGB(22,20,12),  sidebar=Color3.fromRGB(16,14,8),   element=Color3.fromRGB(40,36,22),  elementHover=Color3.fromRGB(52,46,28),  accent=Color3.fromRGB(255,210,80),  text=Color3.fromRGB(250,245,228), subtext=Color3.fromRGB(170,160,125), stroke=Color3.fromRGB(58,52,34)},
    Tem9  = {name="Tem9 · Чёрный",  bg=Color3.fromRGB(0,0,0),     sidebar=Color3.fromRGB(6,6,6),     element=Color3.fromRGB(16,16,16),  elementHover=Color3.fromRGB(26,26,26),  accent=Color3.fromRGB(220,220,220), text=Color3.fromRGB(245,245,245), subtext=Color3.fromRGB(140,140,140), stroke=Color3.fromRGB(32,32,32)},
    Tem10 = {name="Tem10 · Светлый",bg=Color3.fromRGB(245,245,248),sidebar=Color3.fromRGB(228,228,236),element=Color3.fromRGB(214,214,226),elementHover=Color3.fromRGB(198,198,214),accent=Color3.fromRGB(110,70,220),  text=Color3.fromRGB(25,25,40),    subtext=Color3.fromRGB(90,90,115),  stroke=Color3.fromRGB(190,190,208)},
}
-- Автогенерация accent2 (для градиентов)
for _, t in pairs(Themes) do
    t.accent2 = Color3.new(
        math.clamp(t.accent.R * 0.55, 0, 1),
        math.clamp(t.accent.G * 0.55, 0, 1),
        math.clamp(t.accent.B * 0.55, 0, 1)
    )
end

local CurrentTheme = Themes.Tem1
local themeRegistry = {}
local refreshCallbacks = {}

local function setC(inst, prop, role)
    table.insert(themeRegistry, {inst=inst, prop=prop, role=role})
    inst[prop] = CurrentTheme[role]
end

local function applyTheme(name)
    CurrentTheme = Themes[name] or Themes.Tem1
    for i = #themeRegistry, 1, -1 do
        local r = themeRegistry[i]
        if r.inst and r.inst.Parent then
            pcall(function() r.inst[r.prop] = CurrentTheme[r.role] end)
        else
            table.remove(themeRegistry, i)
        end
    end
    for _, fn in ipairs(refreshCallbacks) do pcall(fn) end
end

function Library:SetTheme(name) applyTheme(name) end

-- ══════════════════════════ ХЕЛПЕРЫ ══════════════════════════
local function new(cls, props)
    local i = Instance.new(cls)
    if props then for k, v in pairs(props) do i[k] = v end end
    return i
end
local function corner(p, r) return new("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p}) end
local function tstroke(p, thick)
    local s = new("UIStroke", {Thickness = thick or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p})
    setC(s, "Color", "stroke")
    return s
end
local function tw(o, p, d, style, dir)
    local t = TweenService:Create(o,
        TweenInfo.new(d or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out),
        p)
    t:Play()
    return t
end
local function gradient(p, c1, c2, rot)
    return new("UIGradient", {Color = ColorSequence.new(c1, c2), Rotation = rot or 0, Parent = p})
end

-- ══════════════════════════ УВЕДОМЛЕНИЯ ══════════════════════════
local notifySG = new("ScreenGui", {
    Name = "NewUpNotify", ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100,
    Parent = guiParent,
})
local notifyContainer = new("Frame", {
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -20, 0, 20),
    Size = UDim2.new(0, 300, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, Parent = notifySG,
})
new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 8), Parent = notifyContainer})

local notifyOrder = 0
function Library:Notify(title, text, duration)
    duration = duration or 3
    notifyOrder = notifyOrder + 1

    local card = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), BackgroundColor3 = CurrentTheme.bg,
        BorderSizePixel = 0, Parent = notifyContainer, LayoutOrder = notifyOrder,
        ClipsDescendants = true,
    })
    corner(card, 10)
    local stroke = new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = CurrentTheme.stroke, Parent = card})
    local accentBar = new("Frame", {
        Size = UDim2.new(0, 3, 1, -16), Position = UDim2.new(0, 0, 0, 8),
        BackgroundColor3 = CurrentTheme.accent, BorderSizePixel = 0, Parent = card,
    })
    corner(accentBar, 2)
    local titleLbl = new("TextLabel", {
        Position = UDim2.new(0, 14, 0, 10), Size = UDim2.new(1, -28, 0, 18),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = title or "Notification",
        TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = CurrentTheme.text,
        TextTruncate = Enum.TextTruncate.AtEnd, Parent = card,
    })
    local bodyLbl = new("TextLabel", {
        Position = UDim2.new(0, 14, 0, 30), Size = UDim2.new(1, -28, 0, 30),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = text or "",
        TextSize = 11, TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top, TextColor3 = CurrentTheme.subtext,
        Parent = card,
    })

    tw(card, {Size = UDim2.new(1, 0, 0, 62)}, 0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.delay(duration, function()
        if not card.Parent then return end
        local t = tw(card, {Size = UDim2.new(1, 0, 0, 0)}, 0.28)
        t.Completed:Connect(function()
            if card and card.Parent then card:Destroy() end
        end)
    end)
end

-- ══════════════════════════ ГЛАВНЫЙ SG ══════════════════════════
local sg = new("ScreenGui", {
    Name = "NewUpLibrary", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true,
    DisplayOrder = 50, Parent = guiParent,
})

-- ══════════════════════════ CREATE LIB ══════════════════════════
function Library.CreateLib(name, themeName)
    name = name or "NewUp"
    applyTheme(themeName or "Tem1")

    -- ── Тень окна (сзади) ─────────────────────────────────
    local shadow = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 8),
        Size = UDim2.new(0, 580, 0, 420), BackgroundColor3 = Color3.fromRGB(0,0,0),
        BackgroundTransparency = 0.55, BorderSizePixel = 0, Parent = sg, ZIndex = 1,
    })
    corner(shadow, 18)

    local win = new("Frame", {
        Name = "Window", AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 0, 0, 0),
        ClipsDescendants = true, Parent = sg, ZIndex = 2,
    })
    corner(win, 12)
    setC(win, "BackgroundColor3", "bg")
    tstroke(win)

    -- Intro-анимация открытия
    task.spawn(function()
        tw(win, {Size = UDim2.new(0, 560, 0, 400)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tw(shadow, {Size = UDim2.new(0, 580, 0, 420)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)

    -- ── Sidebar ───────────────────────────────────────────
    local sidebar = new("Frame", {Size = UDim2.new(0, 150, 1, 0), BorderSizePixel = 0, Parent = win, ZIndex = 1})
    corner(sidebar, 12)
    setC(sidebar, "BackgroundColor3", "sidebar")

    local divider = new("Frame", {Position = UDim2.new(0, 150, 0, 8), Size = UDim2.new(0, 1, 1, -16), BorderSizePixel = 0, ZIndex = 3, Parent = win})
    setC(divider, "BackgroundColor3", "stroke")

    local titleLbl = new("TextLabel", {
        Position = UDim2.new(0, 16, 0, 16), Size = UDim2.new(1, -32, 0, 20),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = name,
        TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = sidebar,
    })
    setC(titleLbl, "TextColor3", "text")

    local subLbl = new("TextLabel", {
        Position = UDim2.new(0, 16, 0, 36), Size = UDim2.new(1, -32, 0, 14),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = "by VordAudi",
        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 4, Parent = sidebar,
    })
    setC(subLbl, "TextColor3", "subtext")

    local tabList = new("Frame", {
        Position = UDim2.new(0, 0, 0, 62), Size = UDim2.new(1, 0, 1, -62),
        BackgroundTransparency = 1, ZIndex = 4, Parent = sidebar,
    })
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = tabList})
    new("UIPadding", {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 4), Parent = tabList})

    -- ── Кнопки окна (мин / закрыть) ──────────────────────
    local closeBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 12),
        Size = UDim2.new(0, 22, 0, 22), BackgroundColor3 = Color3.fromRGB(240,90,100),
        BackgroundTransparency = 0.15, Text = "×", Font = Enum.Font.GothamBold,
        TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255), Parent = win, ZIndex = 20,
    })
    corner(closeBtn, 6)

    local minBtn = new("TextButton", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -40, 0, 12),
        Size = UDim2.new(0, 22, 0, 22), BackgroundColor3 = Color3.fromRGB(255,190,70),
        BackgroundTransparency = 0.15, Text = "–", Font = Enum.Font.GothamBold,
        TextSize = 16, TextColor3 = Color3.fromRGB(255,255,255), Parent = win, ZIndex = 20,
    })
    corner(minBtn, 6)

    -- ── Контент ───────────────────────────────────────────
    local content = new("ScrollingFrame", {
        Position = UDim2.new(0, 151, 0, 0), Size = UDim2.new(1, -151, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, Parent = win, ZIndex = 1,
        ClipsDescendants = true,
    })
    corner(content, 12)
    setC(content, "ScrollBarImageColor3", "accent")
    new("UIPadding", {
        PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 20), Parent = content,
    })

    -- ── Перетаскивание ────────────────────────────────────
    local drag, dragS, startP
    sidebar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; dragS = i.Position; startP = win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragS
            win.Position = UDim2.new(startP.X.Scale, startP.X.Offset + d.X, startP.Y.Scale, startP.Y.Offset + d.Y)
            shadow.Position  = UDim2.new(startP.X.Scale, startP.X.Offset + d.X, startP.Y.Scale, startP.Y.Offset + d.Y + 8)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)

    -- ── Ресайз-хэндл ──────────────────────────────────────
    local resizeHandle = new("TextButton", {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -4, 1, -4),
        Size = UDim2.new(0, 18, 0, 18), BackgroundTransparency = 1, Text = "◢",
        Font = Enum.Font.GothamBold, TextSize = 14, ZIndex = 10, Parent = win,
    })
    setC(resizeHandle, "TextColor3", "subtext")

    local resizing, resizeStart, startSize
    resizeHandle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            resizing = true; resizeStart = i.Position; startSize = win.AbsoluteSize
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if resizing and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - resizeStart
            win.Size = UDim2.new(0,
                math.clamp(startSize.X + delta.X, 380, 1000),
                math.clamp(startSize.Y + delta.Y, 280, 800))
            shadow.Size = win.Size + UDim2.new(0, 20, 0, 20)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then resizing = false end
    end)

    -- ── API окна ──────────────────────────────────────────
    local Window = {}
    Window.IsOpen = true
    local allTabs = {}
    local activeTab = nil
    local lastSize = UDim2.new(0, 560, 0, 400)

    function Window.Size(sizeStr)
        if type(sizeStr) == "string" then
            local w, h = string.match(sizeStr, "(%d+)x(%d+)")
            if w and h then
                win.Size = UDim2.new(0, tonumber(w), 0, tonumber(h))
                shadow.Size = win.Size + UDim2.new(0, 20, 0, 20)
                lastSize = win.Size
            end
        elseif type(sizeStr) == "number" then
            win.Size = UDim2.new(0, sizeStr, 0, sizeStr)
            shadow.Size = win.Size + UDim2.new(0, 20, 0, 20)
            lastSize = win.Size
        end
    end

    local function selectTab(t)
        activeTab = t
        for _, o in ipairs(allTabs) do
            tw(o.btn, {BackgroundColor3 = CurrentTheme.sidebar}, 0.12)
            tw(o.indicator, {BackgroundTransparency = 1}, 0.12)
            o.btn.TextColor3 = CurrentTheme.subtext
            o.page.Visible = false
        end
        tw(t.btn, {BackgroundColor3 = CurrentTheme.element}, 0.12)
        tw(t.indicator, {BackgroundTransparency = 0}, 0.12)
        t.btn.TextColor3 = CurrentTheme.text
        t.page.Visible = true
    end

    -- refresh при смене темы
    table.insert(refreshCallbacks, function()
        if activeTab then selectTab(activeTab) end
    end)

    function Window:SetTheme(themeName) applyTheme(themeName) end
    function Window:SelectTab(tabName)
        for _, t in ipairs(allTabs) do
            if t.name == tabName then selectTab(t) return end
        end
    end

    function Window:NewTab(tabName, icon)
        local hasIcon = type(icon) == "string" and #icon > 0
        local btn = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            Text = hasIcon and ("    " .. tabName) or (" " .. tabName),
            TextSize = 13, Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false, Parent = tabList,
        })
        corner(btn, 8)
        setC(btn, "BackgroundColor3", "sidebar")
        setC(btn, "TextColor3", "subtext")

        if hasIcon then
            local iconLbl = new("TextLabel", {
                Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(0, 18, 1, 0),
                BackgroundTransparency = 1, Text = icon, TextSize = 14,
                Font = Enum.Font.GothamBold, Parent = btn, ZIndex = 2,
            })
            setC(iconLbl, "TextColor3", "accent")
        end

        local indicator = new("Frame", {
            Position = UDim2.new(0, -6, 0.5, -8), Size = UDim2.new(0, 3, 0, 16),
            BackgroundTransparency = 1, Parent = btn, ZIndex = 5,
        })
        corner(indicator, 2)
        setC(indicator, "BackgroundColor3", "accent")

        local page = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Visible = false, Parent = content,
        })
        new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12), Parent = page})

        local obj = {btn = btn, page = page, indicator = indicator, name = tabName}
        table.insert(allTabs, obj)
        btn.MouseButton1Click:Connect(function() selectTab(obj) end)
        if #allTabs == 1 then selectTab(obj) end

        local Tab = {}
        function Tab.Size(str) Window.Size(str) end
        function Tab:Select() selectTab(obj) end

        function Tab:NewSection(sectionName)
            local sec = new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = page})
            corner(sec, 10)
            setC(sec, "BackgroundColor3", "element")
            tstroke(sec)
            new("UIPadding", {
                PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = sec,
            })
            local inner = new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = sec})
            new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = inner})

            local title = new("TextLabel", {
                Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1, Font = Enum.Font.GothamBold, Text = sectionName,
                TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = -1, Parent = inner,
            })
            setC(title, "TextColor3", "accent")

            local Section = {}

            -- ══════════ BUTTON ══════════
            function Section:NewButton(text, desc, callback)
                local h = desc and 46 or 34
                local b = new("TextButton", {
                    Size = UDim2.new(1, 0, 0, h), Text = "",
                    AutoButtonColor = false, Parent = inner, ClipsDescendants = true,
                })
                corner(b, 8)
                setC(b, "BackgroundColor3", "bg")
                tstroke(b)

                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -20, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                    Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 3, Parent = b,
                })
                setC(lbl, "TextColor3", "text")

                if desc then
                    local dl = new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23),
                        Size = UDim2.new(1, -20, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                        Text = desc, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 3, Parent = b,
                    })
                    setC(dl, "TextColor3", "subtext")
                end

                b.MouseEnter:Connect(function() tw(b, {BackgroundColor3 = CurrentTheme.elementHover}, 0.1) end)
                b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = CurrentTheme.bg}, 0.1) end)

                local function playPressAnim(cx, cy)
                    local ripple = new("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0, cx, 0, cy),
                        Size = UDim2.new(0, 0, 0, 0),
                        BackgroundColor3 = CurrentTheme.accent,
                        BackgroundTransparency = 0.55,
                        BorderSizePixel = 0, ZIndex = 2, Parent = b,
                    })
                    corner(ripple, 999)
                    local maxSize = math.max(b.AbsoluteSize.X, b.AbsoluteSize.Y) * 2.4
                    tw(ripple, {Size = UDim2.new(0, maxSize, 0, maxSize), BackgroundTransparency = 1}, 0.55)
                    task.delay(0.6, function()
                        if ripple and ripple.Parent then ripple:Destroy() end
                    end)

                    tw(b, {BackgroundColor3 = CurrentTheme.accent}, 0.08)
                    task.delay(0.09, function()
                        if b and b.Parent then
                            tw(b, {BackgroundColor3 = CurrentTheme.elementHover}, 0.2)
                        end
                    end)
                end

                b.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1
                    or input.UserInputType == Enum.UserInputType.Touch then
                        local cx = input.Position.X - b.AbsolutePosition.X
                        local cy = input.Position.Y - b.AbsolutePosition.Y
                        playPressAnim(cx, cy)
                    end
                end)

                b.MouseButton1Click:Connect(function()
                    if callback then
                        local ok, err = pcall(callback)
                        if not ok then warn("[NewUp] Button: " .. tostring(err)) end
                    end
                end)
                return b
            end

            -- ══════════ TOGGLE ══════════
            function Section:NewToggle(text, desc, callback)
                local state = false
                local h = desc and 46 or 34
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, h), Parent = inner, ClipsDescendants = true})
                corner(f, 8)
                setC(f, "BackgroundColor3", "bg")
                tstroke(f)

                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -60, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = text,
                    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 3, Parent = f,
                })
                setC(lbl, "TextColor3", "text")

                if desc then
                    local dl = new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23),
                        Size = UDim2.new(1, -60, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = desc,
                        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left,
                        ZIndex = 3, Parent = f,
                    })
                    setC(dl, "TextColor3", "subtext")
                end

                local sw = new("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 34, 0, 18), ZIndex = 2, Parent = f,
                })
                corner(sw, 9)
                setC(sw, "BackgroundColor3", "elementHover")

                local knob = new("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14), ZIndex = 3, Parent = sw,
                })
                corner(knob, 7)
                setC(knob, "BackgroundColor3", "subtext")

                local hit = new("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
                    Text = "", ZIndex = 4, Parent = f,
                })

                local function refreshState()
                    if state then
                        sw.BackgroundColor3 = CurrentTheme.accent
                        knob.BackgroundColor3 = CurrentTheme.text
                        knob.Position = UDim2.new(1, -16, 0.5, 0)
                    else
                        sw.BackgroundColor3 = CurrentTheme.elementHover
                        knob.BackgroundColor3 = CurrentTheme.subtext
                        knob.Position = UDim2.new(0, 2, 0.5, 0)
                    end
                end
                table.insert(refreshCallbacks, refreshState)

                hit.MouseButton1Click:Connect(function()
                    local rip = new("Frame", {
                        AnchorPoint = Vector2.new(0.5, 0.5),
                        Position = UDim2.new(0.5, 0, 0.5, 0),
                        Size = UDim2.new(0, 0, 0, 0),
                        BackgroundColor3 = CurrentTheme.accent, BackgroundTransparency = 0.55,
                        BorderSizePixel = 0, ZIndex = 2, Parent = f,
                    })
                    corner(rip, 999)
                    local mx = math.max(f.AbsoluteSize.X, f.AbsoluteSize.Y) * 2.2
                    tw(rip, {Size = UDim2.new(0, mx, 0, mx), BackgroundTransparency = 1}, 0.5)
                    task.delay(0.55, function() if rip and rip.Parent then rip:Destroy() end end)

                    state = not state
                    if state then
                        tw(sw,   {BackgroundColor3 = CurrentTheme.accent}, 0.15)
                        tw(knob, {Position = UDim2.new(1, -16, 0.5, 0), BackgroundColor3 = CurrentTheme.text}, 0.15)
                    else
                        tw(sw,   {BackgroundColor3 = CurrentTheme.elementHover}, 0.15)
                        tw(knob, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = CurrentTheme.subtext}, 0.15)
                    end
                    if callback then
                        local ok, err = pcall(callback, state)
                        if not ok then warn("[NewUp] Toggle: " .. tostring(err)) end
                    end
                end)
                return f
            end

            -- ══════════ SLIDER ══════════
            function Section:NewSlider(text, desc, maxV, minV, callback)
                maxV = maxV or 100; minV = minV or 0
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, 52), Parent = inner})
                corner(f, 8)
                setC(f, "BackgroundColor3", "bg")
                tstroke(f)

                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -80, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                    Text = text, TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                setC(lbl, "TextColor3", "text")

                if desc then
                    local dl = new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 22), Size = UDim2.new(1, -80, 0, 14),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = desc,
                        TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                    setC(dl, "TextColor3", "subtext")
                end

                local valLbl = new("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 5),
                    Size = UDim2.new(0, 60, 0, 18), BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold, Text = tostring(minV), TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Right, Parent = f,
                })
                setC(valLbl, "TextColor3", "accent")

                local bar = new("Frame", {Position = UDim2.new(0, 10, 1, -14), Size = UDim2.new(1, -20, 0, 6), Parent = f})
                corner(bar, 3)
                setC(bar, "BackgroundColor3", "elementHover")

                local fill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), Parent = bar})
                corner(fill, 3)
                setC(fill, "BackgroundColor3", "accent")
                gradient(fill, CurrentTheme.accent, CurrentTheme.accent2, 0)

                local knob = new("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12), Parent = bar,
                })
                corner(knob, 6)
                setC(knob, "BackgroundColor3", "text")

                local sliding = false
                local function setVal(px)
                    local rel = math.clamp((px - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local v = math.floor(minV + (maxV - minV) * rel + 0.5)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    knob.Position = UDim2.new(rel, 0, 0.5, 0)
                    valLbl.Text = tostring(v)
                    if callback then
                        local ok, err = pcall(callback, v)
                        if not ok then warn("[NewUp] Slider: " .. tostring(err)) end
                    end
                end

                local hit = new("TextButton", {
                    Position = UDim2.new(0, 0, 0, 20), Size = UDim2.new(1, 0, 0, 32),
                    BackgroundTransparency = 1, Text = "", Parent = f,
                })
                hit.InputBegan:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        sliding = true; setVal(i.Position.X)
                    end
                end)
                UserInputService.InputChanged:Connect(function(i)
                    if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                        setVal(i.Position.X)
                    end
                end)
                UserInputService.InputEnded:Connect(function(i)
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = false end
                end)
                return f
            end

            -- ══════════ LABEL ══════════
            function Section:NewLabel(text)
                local l = new("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham, Text = text, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = inner,
                })
                setC(l, "TextColor3", "subtext")
                return l
            end

            -- ══════════ PARAGRAPH ══════════
            function Section:NewParagraph(title, text)
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = inner})
                corner(f, 8)
                setC(f, "BackgroundColor3", "bg")
                tstroke(f)
                new("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = f})
                local t = new("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold, Text = title or "", TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                setC(t, "TextColor3", "text")
                local b = new("TextLabel", {
                    Position = UDim2.new(0, 0, 0, 18), Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham, Text = text or "", TextSize = 11,
                    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top, Parent = f,
                })
                setC(b, "TextColor3", "subtext")
                return f
            end

            -- ══════════ DIVIDER ══════════
            function Section:NewDivider()
                local d = new("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundTransparency = 0.4, Parent = inner})
                setC(d, "BackgroundColor3", "stroke")
                return d
            end

            -- ══════════ TEXTBOX ══════════
            function Section:NewTextBox(text, desc, placeholder, callback)
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, 40), Parent = inner})
                corner(f, 8)
                setC(f, "BackgroundColor3", "bg")
                tstroke(f)

                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, 4), Size = UDim2.new(1, -100, 0, 16),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = text,
                    TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                setC(lbl, "TextColor3", "text")

                local box = new("TextBox", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 110, 0, 22), BackgroundColor3 = CurrentTheme.sidebar,
                    Text = "", PlaceholderText = placeholder or "type...",
                    PlaceholderColor3 = CurrentTheme.subtext, TextColor3 = CurrentTheme.text,
                    Font = Enum.Font.Gotham, TextSize = 12, ClearTextOnFocus = false,
                    Parent = f,
                })
                corner(box, 6)
                new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = CurrentTheme.stroke, Parent = box})
                new("UIPadding", {PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = box})

                box.Focused:Connect(function()
                    tw(box, {BackgroundColor3 = CurrentTheme.elementHover}, 0.12)
                end)
                box.FocusLost:Connect(function(enter)
                    tw(box, {BackgroundColor3 = CurrentTheme.sidebar}, 0.12)
                    if callback then
                        local ok, err = pcall(callback, box.Text, enter)
                        if not ok then warn("[NewUp] TextBox: " .. tostring(err)) end
                    end
                end)
                return f
            end

            -- ══════════ KEYBIND ══════════
            function Section:NewKeybind(text, desc, defaultKey, callback)
                local state = defaultKey or Enum.KeyCode.RightShift
                local capturing = false
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, desc and 46 or 34), Parent = inner, ClipsDescendants = true})
                corner(f, 8)
                setC(f, "BackgroundColor3", "bg")
                tstroke(f)

                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -100, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = text,
                    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                setC(lbl, "TextColor3", "text")

                if desc then
                    local dl = new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23),
                        Size = UDim2.new(1, -100, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = desc,
                        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                    setC(dl, "TextColor3", "subtext")
                end

                local kbBtn = new("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 80, 0, 22),
                    BackgroundColor3 = CurrentTheme.sidebar, Text = state.Name,
                    Font = Enum.Font.GothamMedium, TextSize = 12,
                    TextColor3 = CurrentTheme.accent, AutoButtonColor = false, Parent = f,
                })
                corner(kbBtn, 6)
                new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = CurrentTheme.stroke, Parent = kbBtn})

                kbBtn.MouseButton1Click:Connect(function()
                    capturing = true
                    kbBtn.Text = "…"
                    tw(kbBtn, {BackgroundColor3 = CurrentTheme.elementHover}, 0.12)
                end)

                local conn = UserInputService.InputBegan:Connect(function(input, gp)
                    if not capturing or gp then return end
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        state = input.KeyCode
                        capturing = false
                        kbBtn.Text = state.Name
                        tw(kbBtn, {BackgroundColor3 = CurrentTheme.sidebar}, 0.12)
                        if callback then
                            local ok, err = pcall(callback, state)
                            if not ok then warn("[NewUp] Keybind: " .. tostring(err)) end
                        end
                    end
                end)
                return f
            end

            -- ══════════ DROPDOWN ══════════
            function Section:NewDropdown(text, desc, items, callback)
                items = items or {}
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, desc and 46 or 34), Parent = inner, ClipsDescendants = true})
                corner(f, 8)
                setC(f, "BackgroundColor3", "bg")
                tstroke(f)

                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -100, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium, Text = text,
                    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                setC(lbl, "TextColor3", "text")

                if desc then
                    local dl = new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23),
                        Size = UDim2.new(1, -100, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham, Text = desc,
                        TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                    setC(dl, "TextColor3", "subtext")
                end

                local ddBtn = new("TextButton", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 100, 0, 22),
                    BackgroundColor3 = CurrentTheme.sidebar, Text = "Выбрать ▾",
                    Font = Enum.Font.GothamMedium, TextSize = 11,
                    TextColor3 = CurrentTheme.accent, AutoButtonColor = false, Parent = f,
                })
                corner(ddBtn, 6)
                new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = CurrentTheme.stroke, Parent = ddBtn})

                ddBtn.MouseButton1Click:Connect(function()
                    -- popup слой
                    local absPos = ddBtn.AbsolutePosition
                    local absSize = ddBtn.AbsoluteSize
                    local rowH = 26
                    local popupH = #items * rowH + 8

                    local popup = new("Frame", {
                        Position = UDim2.new(0, absPos.X - 100, 0, absPos.Y + absSize.Y + 4),
                        Size = UDim2.new(0, 200, 0, 0),
                        BackgroundColor3 = CurrentTheme.bg, BorderSizePixel = 0,
                        Parent = sg, ZIndex = 100, ClipsDescendants = true,
                    })
                    corner(popup, 8)
                    new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = CurrentTheme.stroke, Parent = popup})
                    new("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), Parent = popup})

                    local list = new("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Parent = popup})
                    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = list})

                    for i, item in ipairs(items) do
                        local row = new("TextButton", {
                            Size = UDim2.new(1, 0, 0, rowH), BackgroundColor3 = CurrentTheme.bg,
                            Text = "  " .. tostring(item), Font = Enum.Font.Gotham,
                            TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
                            TextColor3 = CurrentTheme.text, AutoButtonColor = false,
                            LayoutOrder = i, Parent = list,
                        })
                        corner(row, 6)
                        row.MouseEnter:Connect(function() tw(row, {BackgroundColor3 = CurrentTheme.elementHover}, 0.1) end)
                        row.MouseLeave:Connect(function() tw(row, {BackgroundColor3 = CurrentTheme.bg}, 0.1) end)
                        row.MouseButton1Click:Connect(function()
                            ddBtn.Text = tostring(item) .. " ▾"
                            if callback then
                                local ok, err = pcall(callback, item)
                                if not ok then warn("[NewUp] Dropdown: " .. tostring(err)) end
                            end
                            popup:Destroy()
                        end)
                    end

                    -- закрытие при клике вне
                    local closeConn
                    closeConn = UserInputService.InputBegan:Connect(function(inp, gp)
                        if gp then return end
                        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                            local mx, my = inp.Position.X, inp.Position.Y
                            local inside = mx >= popup.AbsolutePosition.X and mx <= popup.AbsolutePosition.X + popup.AbsoluteSize.X
                                and my >= popup.AbsolutePosition.Y and my <= popup.AbsolutePosition.Y + popup.AbsoluteSize.Y
                            if not inside then
                                popup:Destroy()
                                closeConn:Disconnect()
                            end
                        end
                    end)

                    tw(popup, {Size = UDim2.new(0, 200, 0, popupH)}, 0.2)
                end)
                return f
            end

            return Section
        end
        return Tab
    end

    -- ── Тоггл / close / destroy ───────────────────────────
    local function hideWindow(cb)
        lastSize = win.Size
        local targetW = lastSize.X.Offset * 0.9
        local targetH = lastSize.Y.Offset * 0.9
        local t1 = tw(win,    {Size = UDim2.new(0, targetW, 0, targetH)}, 0.18)
        local t2 = tw(shadow, {Size = UDim2.new(0, targetW + 20, 0, targetH + 20)}, 0.18)
        t1.Completed:Connect(function()
            win.Visible = false; shadow.Visible = false
            if cb then cb() end
        end)
    end

    local function showWindow()
        win.Visible = true; shadow.Visible = true
        win.Size = UDim2.new(0, lastSize.X.Offset * 0.9, 0, lastSize.Y.Offset * 0.9)
        shadow.Size = UDim2.new(0, lastSize.X.Offset * 0.9 + 20, 0, lastSize.Y.Offset * 0.9 + 20)
        tw(win,    {Size = lastSize}, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        tw(shadow, {Size = UDim2.new(0, lastSize.X.Offset + 20, 0, lastSize.Y.Offset + 20)}, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end

    function Window:Toggle()
        Window.IsOpen = not Window.IsOpen
        if Window.IsOpen then showWindow() else hideWindow() end
    end

    function Window:Hide()  if Window.IsOpen then Window:Toggle() end end
    function Window:Show()  if not Window.IsOpen then Window:Toggle() end end

    minBtn.MouseButton1Click:Connect(function()
        if Window.IsOpen then hideWindow() ; Window.IsOpen = false end
    end)
    closeBtn.MouseButton1Click:Connect(function()
        sg:Destroy(); notifySG:Destroy()
    end)

    function Window:Destroy() sg:Destroy(); notifySG:Destroy() end

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if UserInputService:GetFocusedTextBox() then return end
        if i.KeyCode == Enum.KeyCode.RightShift then Window:Toggle() end
    end)

    return Window
end

function Library:Destroy() sg:Destroy(); notifySG:Destroy() end

-- Приветствие
task.spawn(function()
    task.wait(0.35)
    Library:Notify("NewUp UI v14", "Загружено. RightShift — скрыть/показать.", 4)
end)

return Library
