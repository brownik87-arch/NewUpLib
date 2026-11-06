-- ══════════════════════════════════════════════════════════════
--  NewUp UI Library v2.1 (fix)
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

-- Определяем родителя GUI (CoreGui или PlayerGui)
local guiParent
pcall(function()
    local cg = game:GetService("CoreGui")
    local _ = cg:GetChildren()
    guiParent = cg
end)
if not guiParent then
    guiParent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- Тема
local T = {
    Bg = Color3.fromRGB(18, 18, 24),
    Sidebar = Color3.fromRGB(14, 14, 19),
    Element = Color3.fromRGB(30, 30, 40),
    ElementHover = Color3.fromRGB(38, 38, 50),
    Accent = Color3.fromRGB(140, 85, 255),
    Text = Color3.fromRGB(238, 238, 245),
    SubText = Color3.fromRGB(135, 135, 155),
    Stroke = Color3.fromRGB(42, 42, 55),
}

local function new(cls, props)
    local i = Instance.new(cls)
    if props then for k, v in pairs(props) do i[k] = v end end
    return i
end
local function corner(p, r) return new("UICorner", {CornerRadius = UDim.new(0, r or 8), Parent = p}) end
local function stroke(p, c, t) return new("UIStroke", {Color = c or T.Stroke, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p}) end
local function tw(o, p, d) TweenService:Create(o, TweenInfo.new(d or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p):Play() end

-- ScreenGui (исправлено!)
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
    BackgroundTransparency = 1,
    Parent = sg,
})
new("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 8),
    Parent = notifStack,
})

function Library:Notify(title, content, duration)
    duration = duration or 3
    local card = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.Bg,
        ClipsDescendants = true,
        Parent = notifStack,
    })
    corner(card, 10); stroke(card)
    new("Frame", {
        Size = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = T.Accent,
        BorderSizePixel = 0,
        Parent = card,
    })
    local pad = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Parent = card,
    })
    new("UIPadding", {
        PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 16),
        Parent = pad,
    })
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4), Parent = pad})
    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = title or "NewUp", TextSize = 14, TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true,
        LayoutOrder = 1, Parent = pad,
    })
    new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = content or "", TextSize = 12, TextColor3 = T.SubText,
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
function Library.CreateLib(name, theme)
    name = name or "NewUp"
    if theme == "RJTheme2" then T.Accent = Color3.fromRGB(80, 140, 240)
    elseif theme == "RJTheme3" then T.Accent = Color3.fromRGB(240, 100, 150)
    elseif theme == "RJTheme4" then T.Accent = Color3.fromRGB(100, 220, 140) end

    local win = new("Frame", {
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 560, 0, 400),
        BackgroundColor3 = T.Bg,
        ClipsDescendants = true,
        Parent = sg,
    })
    corner(win, 12); stroke(win)

    -- Сайдбар
    local sidebar = new("Frame", {
        Size = UDim2.new(0, 150, 1, 0),
        BackgroundColor3 = T.Sidebar,
        BorderSizePixel = 0,
        Parent = win,
    })
    corner(sidebar, 12)
    new("Frame", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0),
        Size = UDim2.new(0, 12, 1, 0), BackgroundColor3 = T.Sidebar,
        BorderSizePixel = 0, Parent = sidebar,
    })
    new("Frame", {
        Position = UDim2.new(1, -1, 0, 0), Size = UDim2.new(0, 1, 1, 0),
        BackgroundColor3 = T.Stroke, BorderSizePixel = 0, Parent = sidebar,
    })
    new("TextLabel", {
        Position = UDim2.new(0, 16, 0, 16),
        Size = UDim2.new(1, -32, 0, 20),
        BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
        Text = name, TextSize = 16, TextColor3 = T.Text,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = sidebar,
    })
    new("TextLabel", {
        Position = UDim2.new(0, 16, 0, 36),
        Size = UDim2.new(1, -32, 0, 14),
        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
        Text = "by VordAudi", TextSize = 11, TextColor3 = T.SubText,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = sidebar,
    })

    local tabList = new("Frame", {
        Position = UDim2.new(0, 0, 0, 62),
        Size = UDim2.new(1, 0, 1, -62),
        BackgroundTransparency = 1,
        Parent = sidebar,
    })
    new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = tabList})
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 4), Parent = tabList,
    })

    -- Контент
    local content = new("ScrollingFrame", {
        Position = UDim2.new(0, 150, 0, 0),
        Size = UDim2.new(1, -150, 1, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 4, ScrollBarImageColor3 = T.Accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Parent = win,
    })
    new("UIPadding", {
        PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16),
        PaddingLeft = UDim.new(0, 16), PaddingRight = UDim.new(0, 20),
        Parent = content,
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

    -- API
    local Window = {}
    Window.IsOpen = true
    local allTabs = {}

    local function selectTab(t)
        for _, o in ipairs(allTabs) do
            tw(o.btn, {BackgroundColor3 = T.Sidebar}, 0.12)
            o.btn.TextColor3 = T.SubText
            o.page.Visible = false
        end
        tw(t.btn, {BackgroundColor3 = T.Element}, 0.12)
        t.btn.TextColor3 = T.Text
        t.page.Visible = true
    end

    function Window:NewTab(tabName)
        local btn = new("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = T.Sidebar,
            Text = "  "..tabName, TextSize = 13,
            Font = Enum.Font.GothamMedium, TextColor3 = T.SubText,
            TextXAlignment = Enum.TextXAlignment.Left,
            AutoButtonColor = false, Parent = tabList,
        })
        corner(btn, 6)

        local page = new("Frame", {
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
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
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = T.Element, Parent = page,
            })
            corner(sec, 10); stroke(sec)
            new("UIPadding", {
                PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
                PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = sec,
            })
            local inner = new("Frame", {
                Size = UDim2.new(1, 0, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1, Parent = sec,
            })
            new("UIListLayout", {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = inner})
            new("TextLabel", {
                Size = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1, Font = Enum.Font.GothamBold,
                Text = sectionName, TextSize = 13, TextColor3 = T.Accent,
                TextXAlignment = Enum.TextXAlignment.Left,
                LayoutOrder = -1, Parent = inner,
            })

            local Section = {}

            function Section:NewButton(text, desc, callback)
                local h = desc and 46 or 34
                local b = new("TextButton", {
                    Size = UDim2.new(1, 0, 0, h),
                    BackgroundColor3 = T.Bg, Text = "",
                    AutoButtonColor = false, Parent = inner,
                })
                corner(b, 6); stroke(b)
                new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -20, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                    Text = text, TextSize = 13, TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
                })
                if desc then
                    new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23),
                        Size = UDim2.new(1, -20, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                        Text = desc, TextSize = 11, TextColor3 = T.SubText,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = b,
                    })
                end
                b.MouseEnter:Connect(function() tw(b, {BackgroundColor3 = T.ElementHover}, 0.1) end)
                b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = T.Bg}, 0.1) end)
                b.MouseButton1Click:Connect(function()
                    if callback then
                        local ok, err = pcall(callback)
                        if not ok then warn("[NewUp] Button error: "..tostring(err)) end
                    end
                end)
                return b
            end

            function Section:NewToggle(text, desc, callback)
                local state = false
                local h = desc and 46 or 34
                local f = new("Frame", {
                    Size = UDim2.new(1, 0, 0, h),
                    BackgroundColor3 = T.Bg, Parent = inner,
                })
                corner(f, 6); stroke(f)
                new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, desc and 5 or 0),
                    Size = UDim2.new(1, -60, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                    Text = text, TextSize = 13, TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                if desc then
                    new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 23),
                        Size = UDim2.new(1, -60, 0, 16),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                        Text = desc, TextSize = 11, TextColor3 = T.SubText,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                end
                local sw = new("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    Position = UDim2.new(1, -10, 0.5, 0),
                    Size = UDim2.new(0, 34, 0, 18),
                    BackgroundColor3 = T.ElementHover, Parent = f,
                })
                corner(sw, 9)
                local knob = new("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    Position = UDim2.new(0, 2, 0.5, 0),
                    Size = UDim2.new(0, 14, 0, 14),
                    BackgroundColor3 = T.SubText, Parent = sw,
                })
                corner(knob, 7)
                local hit = new("TextButton", {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundTransparency = 1, Text = "", Parent = f,
                })
                hit.MouseButton1Click:Connect(function()
                    state = not state
                    if state then
                        tw(sw, {BackgroundColor3 = T.Accent}, 0.15)
                        tw(knob, {Position = UDim2.new(1, -16, 0.5, 0), BackgroundColor3 = T.Text}, 0.15)
                    else
                        tw(sw, {BackgroundColor3 = T.ElementHover}, 0.15)
                        tw(knob, {Position = UDim2.new(0, 2, 0.5, 0), BackgroundColor3 = T.SubText}, 0.15)
                    end
                    if callback then
                        local ok, err = pcall(callback, state)
                        if not ok then warn("[NewUp] Toggle error: "..tostring(err)) end
                    end
                end)
                return f
            end

            function Section:NewSlider(text, desc, maxV, minV, callback)
                maxV = maxV or 100; minV = minV or 0
                local f = new("Frame", {
                    Size = UDim2.new(1, 0, 0, 52),
                    BackgroundColor3 = T.Bg, Parent = inner,
                })
                corner(f, 6); stroke(f)
                new("TextLabel", {
                    Position = UDim2.new(0, 10, 0, 5),
                    Size = UDim2.new(1, -80, 0, 18),
                    BackgroundTransparency = 1, Font = Enum.Font.GothamMedium,
                    Text = text, TextSize = 13, TextColor3 = T.Text,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                })
                if desc then
                    new("TextLabel", {
                        Position = UDim2.new(0, 10, 0, 22),
                        Size = UDim2.new(1, -80, 0, 14),
                        BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                        Text = desc, TextSize = 10, TextColor3 = T.SubText,
                        TextXAlignment = Enum.TextXAlignment.Left, Parent = f,
                    })
                end
                local valLbl = new("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 5),
                    Size = UDim2.new(0, 60, 0, 18), BackgroundTransparency = 1,
                    Font = Enum.Font.GothamBold, Text = tostring(minV), TextSize = 12,
                    TextColor3 = T.Accent, TextXAlignment = Enum.TextXAlignment.Right, Parent = f,
                })
                local bar = new("Frame", {
                    Position = UDim2.new(0, 10, 1, -14), Size = UDim2.new(1, -20, 0, 6),
                    BackgroundColor3 = T.ElementHover, Parent = f,
                })
                corner(bar, 3)
                local fill = new("Frame", {
                    Size = UDim2.new(0, 0, 1, 0),
                    BackgroundColor3 = T.Accent, Parent = bar,
                })
                corner(fill, 3)
                local knob = new("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    Position = UDim2.new(0, 0, 0.5, 0),
                    Size = UDim2.new(0, 12, 0, 12),
                    BackgroundColor3 = T.Text, Parent = bar,
                })
                corner(knob, 6)

                local sliding = false
                local function setVal(px)
                    local rel = math.clamp((px - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
                    local v = math.floor(minV + (maxV - minV) * rel + 0.5)
                    fill.Size = UDim2.new(rel, 0, 1, 0)
                    knob.Position = UDim2.new(rel, 0, 0.5, 0)
                    valLbl.Text = tostring(v)
                    if callback then
                        local ok, err = pcall(callback, v)
                        if not ok then warn("[NewUp] Slider error: "..tostring(err)) end
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
                return new("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1, Font = Enum.Font.Gotham,
                    Text = text, TextSize = 12, TextColor3 = T.SubText,
                    TextXAlignment = Enum.TextXAlignment.Left, Parent = inner,
                })
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
