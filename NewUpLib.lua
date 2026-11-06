-- ══════════════════════════════════════════════════════════════
--  NewUp UI Library v3  |  10 тем (Tem1..Tem10)
-- ══════════════════════════════════════════════════════════════
local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Чистим старую копию
for _, parent in ipairs({game:GetService("CoreGui"), Players.LocalPlayer:FindFirstChild("PlayerGui")}) do
    if parent then
        pcall(function()
            local old = parent:FindFirstChild("NewUpLibrary")
            if old then old:Destroy() end
        end)
    end
end

-- Родитель GUI
local guiParent
pcall(function()
    local cg = game:GetService("CoreGui")
    local _ = cg:GetChildren()
    guiParent = cg
end)
if not guiParent then guiParent = Players.LocalPlayer:WaitForChild("PlayerGui") end

-- ═══ ТЕМЫ ═══
local Themes = {
    Tem1 = {name="Tem1 · Фиолет",
        bg=Color3.fromRGB(18,18,24), sidebar=Color3.fromRGB(14,14,19),
        element=Color3.fromRGB(30,30,40), elementHover=Color3.fromRGB(38,38,50),
        accent=Color3.fromRGB(140,85,255), text=Color3.fromRGB(238,238,245),
        subtext=Color3.fromRGB(135,135,155), stroke=Color3.fromRGB(42,42,55)},
    Tem2 = {name="Tem2 · Синий",
        bg=Color3.fromRGB(16,18,26), sidebar=Color3.fromRGB(12,14,20),
        element=Color3.fromRGB(28,32,44), elementHover=Color3.fromRGB(36,42,58),
        accent=Color3.fromRGB(80,140,240), text=Color3.fromRGB(232,238,248),
        subtext=Color3.fromRGB(130,140,165), stroke=Color3.fromRGB(40,46,62)},
    Tem3 = {name="Tem3 · Розовый",
        bg=Color3.fromRGB(22,16,22), sidebar=Color3.fromRGB(16,12,16),
        element=Color3.fromRGB(38,28,38), elementHover=Color3.fromRGB(48,36,48),
        accent=Color3.fromRGB(240,100,150), text=Color3.fromRGB(248,232,238),
        subtext=Color3.fromRGB(165,130,145), stroke=Color3.fromRGB(54,40,54)},
    Tem4 = {name="Tem4 · Зелёный",
        bg=Color3.fromRGB(16,22,18), sidebar=Color3.fromRGB(12,16,13),
        element=Color3.fromRGB(28,38,32), elementHover=Color3.fromRGB(36,48,41),
        accent=Color3.fromRGB(100,220,140), text=Color3.fromRGB(232,248,238),
        subtext=Color3.fromRGB(130,165,142), stroke=Color3.fromRGB(40,54,44)},
    Tem5 = {name="Tem5 · Красный",
        bg=Color3.fromRGB(22,16,18), sidebar=Color3.fromRGB(16,12,13),
        element=Color3.fromRGB(38,28,30), elementHover=Color3.fromRGB(48,36,38),
        accent=Color3.fromRGB(240,90,100), text=Color3.fromRGB(248,232,234),
        subtext=Color3.fromRGB(165,130,132), stroke=Color3.fromRGB(54,40,42)},
    Tem6 = {name="Tem6 · Оранжевый",
        bg=Color3.fromRGB(22,18,14), sidebar=Color3.fromRGB(16,13,10),
        element=Color3.fromRGB(38,32,26), elementHover=Color3.fromRGB(48,41,33),
        accent=Color3.fromRGB(255,150,60), text=Color3.fromRGB(248,240,230),
        subtext=Color3.fromRGB(165,150,130), stroke=Color3.fromRGB(54,46,38)},
    Tem7 = {name="Tem7 · Бирюзовый",
        bg=Color3.fromRGB(14,22,22), sidebar=Color3.fromRGB(10,16,16),
        element=Color3.fromRGB(24,38,38), elementHover=Color3.fromRGB(32,48,48),
        accent=Color3.fromRGB(60,220,200), text=Color3.fromRGB(230,248,246),
        subtext=Color3.fromRGB(130,165,162), stroke=Color3.fromRGB(38,54,54)},
    Tem8 = {name="Tem8 · Золотой",
        bg=Color3.fromRGB(22,20,12), sidebar=Color3.fromRGB(16,14,8),
        element=Color3.fromRGB(40,36,22), elementHover=Color3.fromRGB(52,46,28),
        accent=Color3.fromRGB(255,210,80), text=Color3.fromRGB(250,245,228),
        subtext=Color3.fromRGB(170,160,125), stroke=Color3.fromRGB(58,52,34)},
    Tem9 = {name="Tem9 · Чёрный",
        bg=Color3.fromRGB(0,0,0), sidebar=Color3.fromRGB(6,6,6),
        element=Color3.fromRGB(16,16,16), elementHover=Color3.fromRGB(26,26,26),
        accent=Color3.fromRGB(220,220,220), text=Color3.fromRGB(245,245,245),
        subtext=Color3.fromRGB(140,140,140), stroke=Color3.fromRGB(32,32,32)},
    Tem10 = {name="Tem10 · Светлый",
        bg=Color3.fromRGB(245,245,248), sidebar=Color3.fromRGB(228,228,236),
        element=Color3.fromRGB(214,214,226), elementHover=Color3.fromRGB(198,198,214),
        accent=Color3.fromRGB(110,70,220), text=Color3.fromRGB(25,25,40),
        subtext=Color3.fromRGB(90,90,115), stroke=Color3.fromRGB(190,190,208)},
}

-- Алиасы Robojini
Themes.RJTheme1 = Themes.Tem1
Themes.RJTheme2 = Themes.Tem2
Themes.RJTheme3 = Themes.Tem3
Themes.RJTheme4 = Themes.Tem4

-- Реестр элементов для смены темы
local CurrentTheme = Themes.Tem1
local themeRegistry = {}
local function setC(inst, prop, role)
    table.insert(themeRegistry, {inst=inst, prop=prop, role=role})
    inst[prop] = CurrentTheme[role]
end
local function applyTheme(name)
    CurrentTheme = Themes[name] or Themes.Tem1
    for _, r in ipairs(themeRegistry) do
        pcall(function()
            if r.inst and r.inst.Parent then r.inst[r.prop] = CurrentTheme[r.role] end
        end)
    end
end
function Library:SetTheme(name) applyTheme(name) end
function Library:GetThemes() return Themes end

-- Утилиты
local function new(cls, props)
    local i = Instance.new(cls)
    if props then for k, v in pairs(props) do i[k] = v end end
    return i
end
local function corner(p, r) return new("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p}) end
local function tstroke(p)
    local s = new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p})
    setC(s, "Color", "stroke")
    return s
end
local function tw(o, p, d) TweenService:Create(o, TweenInfo.new(d or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play() end

-- ScreenGui
local sg = new("ScreenGui", {
    Name = "NewUpLibrary",
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    Parent = guiParent,
})

-- ═══ Уведомления ═══
local notifStack = new("Frame", {
    AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -20, 1, -20),
    Size = UDim2.new(0, 280, 1, -40),
    BackgroundTransparency = 1, Parent = sg,
})
new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 8), Parent = notifStack,
})

function Library:Notify(title, content, duration)
    duration = duration or 3
    local T = CurrentTheme
    local card = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.bg, ClipsDescendants = true, Parent = notifStack,
    })
    corner(card, 10)
    local s = new("UIStroke", {Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Color = T.stroke, Parent = card})
    new("Frame", {Size = UDim2.new(0, 3, 1, 0), BackgroundColor3 = T.accent, BorderSizePixel = 0, Parent = card})
    local pad = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Parent = card,
    })
    new("UIPadding", {
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16), Parent = pad,
    })
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = pad})
    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = title or "NewUp", TextSize = 14, TextColor3 = T.text,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        LayoutOrder = 1, Parent = pad,
    })
    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = content or "", TextSize = 12, TextColor3 = T.subtext,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        LayoutOrder = 2, Parent = pad,
    })
    card.Position = UDim2.new(1, 300, 0, 0)
    tw(card, {Position = UDim2.new(0, 0, 0, 0)}, 0.25)
    task.delay(duration, function()
        if card and card.Parent then
            tw(card, {Position = UDim2.new(1, 300, 0, 0)}, 0.22)
            task.wait(0.25)
            if card and card.Parent then card:Destroy() end
        end
    end)
end

-- ═══ CreateLib ═══
function Library.CreateLib(name, themeName)
    name = name or "NewUp"
    applyTheme(themeName or "Tem1")

    local win = new("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 560, 0, 400),
        ClipsDescendants = true, Parent = sg,
    })
    corner(win, 12)
    setC(win, "BackgroundColor3", "bg")
    tstroke(win)

    -- Сайдбар
    local sidebar = new("Frame", {
        Size = UDim2.new(0, 150, 1, 0), BorderSizePixel = 0, Parent = win,
    })
    corner(sidebar, 12)
    setC(sidebar, "BackgroundColor3", "sidebar")
    new("Frame", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 12, 1, 0), BorderSizePixel = 0, Parent = sidebar,
    })
    -- этот кусок должен иметь тот же цвет что сайдбар → зарегистрируем
    local sbEdge = sidebar:FindFirstChildOfClass("Frame")
    if sbEdge then setC(sbEdge, "BackgroundColor3", "sidebar") end

    new("Frame", {
        Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0),
        BorderSizePixel = 0, Parent = sidebar,
    })
    -- разделитель (тоже themed)
    local divider = sidebar:FindFirstChildOfClass("Frame") -- второй Frame
    -- правим аккуратно: перечислим оба
    local f1, f2 = nil, nil
    for _, ch in ipairs(sidebar:GetChildren()) do
        if ch:IsA("Frame") then
            if ch.Size == UDim2.new(0, 12, 1, 0) then f1 = ch
            elseif ch.Size == UDim2.new(0, 1, 1, 0) then f2 = ch end
        end
    end
    if f1 then setC(f1, "BackgroundColor3", "sidebar") end
    if f2 then setC(f2, "BackgroundColor3", "stroke") end

    local titleLbl = new("TextLabel", {
        Position = UDim2.new(0, 16, 0, 16), Size = UDim2.new(1, -32, 0, 20),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = name, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, Parent = sidebar,
    })
    setC(titleLbl, "TextColor3", "text")
    local subLbl = new("TextLabel", {
        Position = UDim2.new(0, 16, 0, 36), Size = UDim2.new(1, -32, 0, 14),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "by VordAudi", TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = sidebar,
    })
    setC(subLbl, "TextColor3", "subtext")

    local tabList = new("Frame", {
        Position = UDim2.new(0, 0, 0, 62), Size = UDim2.new(1, 0, 1, -62),
        BackgroundTransparency = 1, Parent = sidebar,
    })
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = tabList})
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 4), Parent = tabList,
    })

    -- Контент
    local content = new("ScrollingFrame", {
        Position = UDim2.new(0, 150, 0, 0), Size = UDim2.new(1, -150, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = win,
    })
    setC(content, "ScrollBarImageColor3", "accent")
    new("UIPadding", {
        PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 20), Parent = content,
    })

    -- Перетаскивание
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
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = false
        end
    end)

    -- API окна
    local Window = {}
    Window.IsOpen = true
    local allTabs = {}

    local function selectTab(t)
        for _, o in ipairs(allTabs) do
            tw(o.btn, {BackgroundColor3 = CurrentTheme.sidebar}, 0.12)
            o.btn.TextColor3 = CurrentTheme.subtext
            o.page.Visible = false
        end
        tw(t.btn, {BackgroundColor3 = CurrentTheme.element}, 0.12)
        t.btn.TextColor3 = CurrentTheme.text
        t.page.Visible = true
    end

    function Window:SetTheme(themeName) applyTheme(themeName) end

    function Window:NewTab(tabName)
        local btn = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            Text = "  "..tabName, TextSize = 13,
            Font = Enum.Font.GothamMedium,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false, Parent = tabList,
        })
        corner(btn, 6)
        setC(btn, "BackgroundColor3", "sidebar")
        setC(btn, "TextColor3", "subtext")

        local page = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Visible = false, Parent = content,
        })
        new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12), Parent = page})

        local obj = {btn = btn, page = page}
        table.insert(allTabs, obj)
        btn.MouseButton1Click:Connect(function() selectTab(obj) end)
        if #allTabs == 1 then selectTab(obj) end

        local Tab = {}
        function Tab:NewSection(sectionName)
            local sec = new("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, Parent = page,
            })
            corner(sec, 10)
            setC(sec, "BackgroundColor3", "element")
            tstroke(sec)
            new("UIPadding", {
                PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = sec,
            })
            local inner = new("Frame", {
                Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = sec,
            })
            new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = inner})
            local title = new("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
                Font = Enum.Font.GothamBold, Text = sectionName, TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = -1, Parent = inner,
            })
            setC(title, "TextColor3", "accent")

            local Section = {}

            function Section:NewButton(text, desc, callback)
                local h = desc and 46 or 34
                local b = new("TextButton", {
                    Size = UDim2.new(1, 0, 0, h), Text = "",
                    AutoButtonColor = false, Parent = inner,
                })
                corner(b, 6)
                setC(b, "BackgroundColor3", "bg")
                tstroke(b)
                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -20, 0, 18), BackgroundTransparency = 1,
                    Font = Enum.Font.GothamMedium, Text = text, TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
                })
                setC(lbl, "TextColor3", "text")
                if desc then
                    local dl = new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23), Size = UDim2.new(1, -20, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                        Text = desc, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
                    })
                    setC(dl, "TextColor3", "subtext")
                end
                b.MouseEnter:Connect(function() tw(b, {BackgroundColor3 = CurrentTheme.elementHover}, 0.1) end)
                b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = CurrentTheme.bg}, 0.1) end)
                b.MouseButton1Click:Connect(function()
                    if callback then
                        local ok, err = pcall(callback)
                        if not ok then warn("[NewUp] Button: "..tostring(err)) end
                    end
                end)
                return b
            end

            function Section:NewToggle(text, desc, callback)
                local state = false
                local h = desc and 46 or 34
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, h), Parent = inner})
                corner(f, 6)
                setC(f, "BackgroundColor3", "bg")
                tstroke(f)
                local lbl = new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -60, 0, 18), BackgroundTransparency = 1,
                    Font = Enum.Font.GothamMedium, Text = text, TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                setC(lbl, "TextColor3", "text")
                if desc then
                    local dl = new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23), Size = UDim2.new(1, -60, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                        Text = desc, TextSize = 11, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                    setC(dl, "TextColor3", "subtext")
                end
                local sw = new("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 34, 0, 18), Parent = f,
                })
                corner(sw, 9)
                setC(sw, "BackgroundColor3", "elementHover")
                local knob = new("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14), Parent = sw,
                })
                corner(knob, 7)
                setC(knob, "BackgroundColor3", "subtext")
                local hit = new("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = "", Parent = f,
                })
                hit.MouseButton1Click:Connect(function()
                    state = not state
                    if state then
                        tw(sw, {BackgroundColor3 = CurrentTheme.accent}, 0.15)
                        tw(knob, {Position = UDim2.new(1, -16, 0.5, 0), BackgroundColor3 = CurrentTheme.text}, 0.15)
                    else
                        tw(sw, {BackgroundColor3 = CurrentTheme.elementHover}, 0.15)
                        tw(knob, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = CurrentTheme.subtext}, 0.15)
                    end
                    if callback then
                        local ok, err = pcall(callback, state)
                        if not ok then warn("[NewUp] Toggle: "..tostring(err)) end
                    end
                end)
                return f
            end

            function Section:NewSlider(text, desc, maxV, minV, callback)
                maxV = maxV or 100; minV = minV or 0
                local f = new("Frame", {Size = UDim2.new(1, 0, 0, 52), Parent = inner})
                corner(f, 6)
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
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                        Text = desc, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
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
                local bar = new("Frame", {
                    Position = UDim2.new(0, 10, 1, -14), Size = UDim2.new(1, -20, 0, 6), Parent = f,
                })
                corner(bar, 3)
                setC(bar, "BackgroundColor3", "elementHover")
                local fill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), Parent = bar})
                corner(fill, 3)
                setC(fill, "BackgroundColor3", "accent")
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
                        if not ok then warn("[NewUp] Slider: "..tostring(err)) end
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
                    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                        sliding = false
                    end
                end)
                return f
            end

            function Section:NewLabel(text)
                local l = new("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1,
                    Font = Enum.Font.Gotham, Text = text, TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = inner,
                })
                setC(l, "TextColor3", "subtext")
                return l
            end

            return Section
        end
        return Tab
    end

    function Window:Toggle()
        Window.IsOpen = not Window.IsOpen
        if Window.IsOpen then
            win.Visible = true
            win.Size = UDim2.new(0, 520, 0, 360)
            tw(win, {Size = UDim2.new(0, 560, 0, 400)}, 0.2)
        else
            tw(win, {Size = UDim2.new(0, 520, 0, 360)}, 0.18)
            task.wait(0.2)
            win.Visible = false
        end
    end
    function Window:Destroy() sg:Destroy() end

    UserInputService.InputBegan:Connect(function(i, gp)
        if gp then return end
        if i.KeyCode == Enum.KeyCode.RightShift then Window:Toggle() end
    end)

    return Window
end

function Library:Destroy() sg:Destroy() end

task.spawn(function()
    task.wait(0.3)
    Library:Notify("NewUp UI", "Загружено. RightShift — скрыть/показать.", 3)
end)

return Library
