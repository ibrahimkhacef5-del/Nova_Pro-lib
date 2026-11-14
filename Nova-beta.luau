--[[
    ═══════════════════════════════════════════════════════════════════
    ✦ NovaUI v1.0 — Fluid Edition
    ================================================================
    ✦ Spring-based animations (Jily-style bounce)
    ✦ Glass morphism + floating shadows
    ✦ Staggered element entrance animations
    ✦ Smooth tab morphing with accent pill
    ✦ Ripple effects on buttons
    ✦ 6 Hand-crafted themes
    ✦ Notifications stack (slide + fade)
    ═══════════════════════════════════════════════════════════════════
]]

if _G.NovaUI_Loaded then return _G.NovaUI_Loaded end

local Nova = {}
Nova.__index = Nova

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local LP               = Players.LocalPlayer

Nova.Flags   = {}
Nova.Items   = {}
Nova.Wins    = {}
Nova.Version = "1.0"

-- ═══════════════════════════════════════════════════════════════════
--                     Themes
-- ═══════════════════════════════════════════════════════════════════
Nova.Palettes = {
    Aurora = {
        bg = Color3.fromRGB(16, 14, 24),
        glass = Color3.fromRGB(28, 24, 42),
        card = Color3.fromRGB(38, 34, 54),
        accent = Color3.fromRGB(150, 130, 255),
        accent2 = Color3.fromRGB(255, 120, 200),
        text = Color3.fromRGB(240, 238, 255),
        sub = Color3.fromRGB(160, 155, 190),
        danger = Color3.fromRGB(255, 85, 110),
        success = Color3.fromRGB(100, 230, 160),
        radius = 16,
    },
    Sakura = {
        bg = Color3.fromRGB(255, 245, 250),
        glass = Color3.fromRGB(255, 235, 245),
        card = Color3.fromRGB(255, 255, 255),
        accent = Color3.fromRGB(255, 120, 170),
        accent2 = Color3.fromRGB(180, 100, 255),
        text = Color3.fromRGB(60, 30, 50),
        sub = Color3.fromRGB(160, 130, 150),
        danger = Color3.fromRGB(230, 60, 90),
        success = Color3.fromRGB(80, 200, 140),
        radius = 18,
    },
    Midnight = {
        bg = Color3.fromRGB(8, 10, 20),
        glass = Color3.fromRGB(16, 20, 36),
        card = Color3.fromRGB(24, 30, 52),
        accent = Color3.fromRGB(100, 170, 255),
        accent2 = Color3.fromRGB(180, 120, 255),
        text = Color3.fromRGB(220, 235, 255),
        sub = Color3.fromRGB(120, 145, 190),
        danger = Color3.fromRGB(255, 80, 100),
        success = Color3.fromRGB(80, 220, 160),
        radius = 14,
    },
    Neon = {
        bg = Color3.fromRGB(8, 4, 18),
        glass = Color3.fromRGB(18, 8, 36),
        card = Color3.fromRGB(28, 14, 50),
        accent = Color3.fromRGB(0, 255, 210),
        accent2 = Color3.fromRGB(255, 60, 180),
        text = Color3.fromRGB(225, 255, 250),
        sub = Color3.fromRGB(140, 200, 210),
        danger = Color3.fromRGB(255, 70, 110),
        success = Color3.fromRGB(0, 255, 170),
        radius = 10,
    },
    Ember = {
        bg = Color3.fromRGB(22, 12, 12),
        glass = Color3.fromRGB(38, 20, 20),
        card = Color3.fromRGB(52, 28, 28),
        accent = Color3.fromRGB(255, 140, 60),
        accent2 = Color3.fromRGB(255, 70, 100),
        text = Color3.fromRGB(255, 235, 225),
        sub = Color3.fromRGB(200, 150, 140),
        danger = Color3.fromRGB(255, 80, 80),
        success = Color3.fromRGB(120, 220, 140),
        radius = 14,
    },
    Frost = {
        bg = Color3.fromRGB(240, 245, 252),
        glass = Color3.fromRGB(230, 238, 250),
        card = Color3.fromRGB(255, 255, 255),
        accent = Color3.fromRGB(70, 130, 220),
        accent2 = Color3.fromRGB(120, 90, 220),
        text = Color3.fromRGB(30, 40, 60),
        sub = Color3.fromRGB(110, 125, 150),
        danger = Color3.fromRGB(240, 80, 90),
        success = Color3.fromRGB(60, 190, 130),
        radius = 18,
    },
}

Nova.Theme = setmetatable({}, { __index = Nova.Palettes.Aurora })
for k, v in pairs(Nova.Palettes.Aurora) do Nova.Theme[k] = v end

-- ═══════════════════════════════════════════════════════════════════
--                     Core helpers
-- ═══════════════════════════════════════════════════════════════════
local function new(c, p)
    local i = Instance.new(c)
    for k, v in pairs(p or {}) do i[k] = v end
    return i
end

local function round(p, r)
    return new("UICorner", { CornerRadius = UDim.new(0, r or Nova.Theme.radius), Parent = p })
end

local function outline(p, col, th, trans)
    return new("UIStroke", {
        Color = col or Nova.Theme.accent, Thickness = th or 1.5,
        Transparency = trans or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p
    })
end

local function anim(o, t, p, style, dir)
    return TweenService:Create(o, TweenInfo.new(t or 0.25,
        style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out), p)
end

-- Spring / back-ease "pop"
local function pop(o, targetProps, t)
    anim(o, t or 0.4, targetProps, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function ripple(parent, color)
    parent.ClipsDescendants = true
    local r = new("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = color or Color3.new(1, 1, 1),
        BackgroundTransparency = 0.6,
        BorderSizePixel = 0, ZIndex = 5, Parent = parent
    })
    new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = r })
    anim(r, 0.5, { Size = UDim2.new(2, 0, 2, 0), BackgroundTransparency = 1 }):Play()
    task.delay(0.5, function() r:Destroy() end)
end

-- ═══════════════════════════════════════════════════════════════════
--                     Theme
-- ═══════════════════════════════════════════════════════════════════
function Nova:SetTheme(name)
    if not Nova.Palettes[name] then return false end
    for k, v in pairs(Nova.Palettes[name]) do Nova.Theme[k] = v end
    for _, w in ipairs(Nova.Wins) do
        if w.RefreshTheme then pcall(function() w:RefreshTheme() end) end
    end
    return true
end

-- ═══════════════════════════════════════════════════════════════════
--                     Notifications (stacked, Jily-style)
-- ═══════════════════════════════════════════════════════════════════
Nova._notifs = {}
function Nova:Notify(cfg)
    cfg = cfg or {}
    local gui = new("ScreenGui", {
        Name = "NovaNotif_" .. tostring(math.random(1, 99999)),
        ResetOnSpawn = false, DisplayOrder = 2147483647,
        IgnoreGuiInset = true,
        Parent = LP:WaitForChild("PlayerGui")
    })

    local card = new("Frame", {
        Size = UDim2.new(0, 280, 0, 56),
        Position = UDim2.new(1, 20, 0, 20), -- offscreen right
        BackgroundColor3 = Nova.Theme.glass,
        BackgroundTransparency = 0.05,
        BorderSizePixel = 0, Parent = gui
    })
    round(card, Nova.Theme.radius)
    outline(card, cfg.color or Nova.Theme.accent, 1.5, 0.4)

    -- shadow
    local sh = new("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 3),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.7, BorderSizePixel = 0, ZIndex = 0,
        Parent = card
    })
    round(sh, Nova.Theme.radius)

    -- accent bar
    local bar = new("Frame", {
        Size = UDim2.new(0, 4, 0.6, 0),
        Position = UDim2.new(0, 8, 0.2, 0),
        BackgroundColor3 = cfg.color or Nova.Theme.accent,
        BorderSizePixel = 0, Parent = card
    })
    round(bar, 2)

    new("TextLabel", {
        Size = UDim2.new(1, -30, 0, 18),
        Position = UDim2.new(0, 20, 0, 9),
        BackgroundTransparency = 1,
        Text = cfg.title or "Notification",
        TextColor3 = cfg.color or Nova.Theme.accent,
        TextSize = 12, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = card
    })

    new("TextLabel", {
        Size = UDim2.new(1, -30, 0, 22),
        Position = UDim2.new(0, 20, 0, 26),
        BackgroundTransparency = 1,
        Text = cfg.text or "",
        TextColor3 = Nova.Theme.sub, TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true, Parent = card
    })

    local idx = #Nova._notifs + 1
    table.insert(Nova._notifs, card)

    -- staggered stack positions
    for i, f in ipairs(Nova._notifs) do
        local targetY = 20 + (i - 1) * 64
        if f == card then
            pop(f, { Position = UDim2.new(1, -300, 0, targetY) }, 0.5):Play()
        else
            anim(f, 0.3, { Position = UDim2.new(1, -300, 0, targetY) }):Play()
        end
    end

    task.delay(cfg.duration or 4, function()
        anim(card, 0.3, { Position = UDim2.new(1, 20, 0, card.Position.Y.Offset),
                          BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        for i, f in ipairs(Nova._notifs) do
            if f == card then table.remove(Nova._notifs, i) break end
        end
        gui:Destroy()
        -- reflow remaining
        for i, f in ipairs(Nova._notifs) do
            anim(f, 0.3, { Position = UDim2.new(1, -300, 0, 20 + (i - 1) * 64) }):Play()
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--                     Save / Load
-- ═══════════════════════════════════════════════════════════════════
function Nova:Save(file)
    if not writefile then return end
    file = file or "NovaConfig.json"
    pcall(function() writefile(file, HttpService:JSONEncode(Nova.Flags)) end)
    self:Notify({ title = "Saved", text = "Config written", color = Nova.Theme.success })
end

function Nova:Load(file)
    if not (readfile and isfile) then return end
    file = file or "NovaConfig.json"
    if not isfile(file) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(file)) end)
    if not ok or type(data) ~= "table" then return end
    for _, it in ipairs(Nova.Items) do
        if it.flag and data[it.flag] ~= nil and it.Set then pcall(it.Set, data[it.flag]) end
    end
    self:Notify({ title = "Loaded", text = "Config restored", color = Nova.Theme.success })
end

-- ═══════════════════════════════════════════════════════════════════
--                     Window
-- ═══════════════════════════════════════════════════════════════════
function Nova.new(cfg)
    cfg = cfg or {}
    local self = setmetatable({}, Nova)
    self.Title    = cfg.Title or "Nova"
    self.Subtitle = cfg.Subtitle or "v1.0 · fluid"
    self.Icon     = cfg.Icon or "✦"
    self.Size     = cfg.Size or UDim2.new(0, 420, 0, 340)
    self.Hotkey   = cfg.ToggleKey or Enum.KeyCode.RightShift
    self.Open     = false
    self.Tabs     = {}
    self.Active   = nil

    self.Gui = new("ScreenGui", {
        Name = "Nova_" .. tostring(math.random(10000, 99999)),
        ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 2147483647,
        Parent = LP:WaitForChild("PlayerGui")
    })

    self:_build()
    self:_buildFloating()
    table.insert(Nova.Wins, self)
    return self
end

function Nova:_build()
    local win = new("Frame", {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -self.Size.X.Offset / 2, 0.5, -self.Size.Y.Offset / 2),
        BackgroundColor3 = Nova.Theme.bg,
        BorderSizePixel = 0, Visible = false, Active = true,
        ClipsDescendants = true, Parent = self.Gui
    })
    round(win, Nova.Theme.radius + 4)
    outline(win, Nova.Theme.accent, 1.5, 0.5)

    -- floating shadow
    local sh = new("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 4),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.6, BorderSizePixel = 0,
        ZIndex = 0, Parent = win
    })
    round(sh, Nova.Theme.radius + 4)

    self.Win = win

    -- ═════ Top bar (draggable, glassy) ═════
    local top = new("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Nova.Theme.glass,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0, Active = true, Parent = win
    })
    round(top, Nova.Theme.radius + 4)
    new("Frame", {
        Size = UDim2.new(1, 0, 0, 14),
        Position = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = Nova.Theme.glass,
        BackgroundTransparency = 0.2, BorderSizePixel = 0, Parent = top
    })

    -- logo avatar with soft glow
    local logo = new("Frame", {
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(0, 12, 0.5, -17),
        BackgroundColor3 = Nova.Theme.accent,
        BorderSizePixel = 0, Parent = top
    })
    round(logo, 17)
    new("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = self.Icon,
        TextColor3 = Nova.Theme.bg, TextSize = 18,
        Font = Enum.Font.GothamBold, Parent = logo
    })
    -- pulse glow
    local glow = new("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1, BorderSizePixel = 0, Parent = logo
    })
    round(glow, 17)
    local glowStroke = outline(glow, Nova.Theme.accent, 2, 0.4)
    task.spawn(function()
        while logo.Parent do
            anim(glow, 1.4, { Size = UDim2.new(1.6, 0, 1.6, 0),
                              Position = UDim2.new(-0.3, 0, -0.3, 0) }):Play()
            anim(glowStroke, 1.4, { Transparency = 1 }):Play()
            task.wait(1.4)
            glow.Size = UDim2.new(1, 0, 1, 0)
            glow.Position = UDim2.new(0, 0, 0, 0)
            glowStroke.Transparency = 0.4
        end
    end)

    new("TextLabel", {
        Size = UDim2.new(0, 220, 0, 18),
        Position = UDim2.new(0, 54, 0, 8),
        BackgroundTransparency = 1, Text = self.Title,
        TextColor3 = Nova.Theme.text, TextSize = 15,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = top
    })

    new("TextLabel", {
        Size = UDim2.new(0, 220, 0, 14),
        Position = UDim2.new(0, 54, 0, 27),
        BackgroundTransparency = 1, Text = self.Subtitle,
        TextColor3 = Nova.Theme.sub, TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = top
    })

    local close = new("TextButton", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(1, -34, 0.5, -13),
        BackgroundColor3 = Nova.Theme.danger,
        Text = "✕", TextColor3 = Color3.new(1, 1, 1),
        TextSize = 11, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, AutoButtonColor = false, Parent = top
    })
    round(close, 13)
    close.MouseEnter:Connect(function()
        anim(close, 0.15, { Size = UDim2.new(0, 30, 0, 30),
                            Position = UDim2.new(1, -36, 0.5, -15) }):Play()
    end)
    close.MouseLeave:Connect(function()
        anim(close, 0.15, { Size = UDim2.new(0, 26, 0, 26),
                            Position = UDim2.new(1, -34, 0.5, -13) }):Play()
    end)
    close.Activated:Connect(function() self:Hide() end)

    -- ═════ Content scroll ═════
    local content = new("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -124),
        Position = UDim2.new(0, 10, 0, 58),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Nova.Theme.accent,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Active = true, Parent = win
    })
    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6), Parent = content
    })
    self.Content = content

    -- ═════ Tab rail with sliding pill ═════
    local rail = new("Frame", {
        Size = UDim2.new(1, -20, 0, 48),
        Position = UDim2.new(0, 10, 1, -56),
        BackgroundColor3 = Nova.Theme.glass,
        BackgroundTransparency = 0.25,
        BorderSizePixel = 0, Parent = win
    })
    round(rail, Nova.Theme.radius)
    outline(rail, Nova.Theme.accent, 1, 0.65)
    self.Rail = rail

    -- sliding highlight pill
    local pill = new("Frame", {
        Size = UDim2.new(0, 0, 0, 34),
        Position = UDim2.new(0, 6, 0.5, -17),
        BackgroundColor3 = Nova.Theme.accent,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0, ZIndex = 1, Parent = rail
    })
    round(pill, Nova.Theme.radius - 4)
    outline(pill, Nova.Theme.accent, 1, 0.3)
    self.Pill = pill

    local scroll = new("ScrollingFrame", {
        Size = UDim2.new(1, -8, 1, -8),
        Position = UDim2.new(0, 4, 0, 4),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 0,
        ScrollingDirection = Enum.ScrollingDirection.X,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.X,
        Active = true, ZIndex = 2, Parent = rail
    })
    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 4), Parent = scroll
    })
    new("UIPadding", {
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4),
        Parent = scroll
    })
    self.TabRail = scroll

    -- Drag
    local dragging, dragStart, startPos = false, nil, nil
    top.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = inp.Position
            startPos = win.Position
        end
    end)
    top.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                     startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    -- hotkey
    UserInputService.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == self.Hotkey then self:Toggle() end
    end)
end

function Nova:_buildFloating()
    local fab = new("TextButton", {
        Size = UDim2.new(0, 54, 0, 54),
        Position = UDim2.new(0, 20, 0.5, -27),
        BackgroundColor3 = Nova.Theme.accent,
        Text = self.Icon, TextColor3 = Nova.Theme.bg,
        TextSize = 24, Font = Enum.Font.GothamBold,
        AutoButtonColor = false, BorderSizePixel = 0, Parent = self.Gui
    })
    round(fab, 27)
    outline(fab, Nova.Theme.bg, 3)

    -- spinning halo
    local halo = new("Frame", {
        Size = UDim2.new(1, 8, 1, 8),
        Position = UDim2.new(0, -4, 0, -4),
        BackgroundTransparency = 1, BorderSizePixel = 0, Parent = fab
    })
    round(halo, 31)
    local hs = outline(halo, Nova.Theme.accent2, 2, 0.5)

    task.spawn(function()
        while fab.Parent do
            anim(halo, 2, { Rotation = halo.Rotation + 180 }):Play()
            task.wait(2)
        end
    end)

    -- gentle float bob
    task.spawn(function()
        while fab.Parent do
            anim(fab, 1.2, { Position = UDim2.new(0, 20, 0.5, -30) },
                Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
            task.wait(1.2)
            anim(fab, 1.2, { Position = UDim2.new(0, 20, 0.5, -27) },
                Enum.EasingStyle.Sine, Enum.EasingDirection.InOut):Play()
            task.wait(1.2)
        end
    end)

    fab.MouseButton1Click:Connect(function() self:Toggle() end)
    self.Fab = fab
end

function Nova:Show()
    self.Open = true
    self.Win.Visible = true
    self.Win.Size = UDim2.new(0, 0, 0, 0)
    pop(self.Win, { Size = self.Size }, 0.45):Play()
end

function Nova:Hide()
    self.Open = false
    anim(self.Win, 0.25, { Size = UDim2.new(0, 0, 0, 0) }):Play()
    task.delay(0.25, function() self.Win.Visible = false end)
end

function Nova:Toggle()
    if self.Open then self:Hide() else self:Show() end
end

function Nova:RefreshTheme()
    if not self.Win then return end
    anim(self.Win, 0.3, { BackgroundColor3 = Nova.Theme.bg }):Play()
    anim(self.Rail, 0.3, { BackgroundColor3 = Nova.Theme.glass }):Play()
    anim(self.Pill, 0.3, { BackgroundColor3 = Nova.Theme.accent }):Play()
end

-- ═══════════════════════════════════════════════════════════════════
--                     Tabs (Jily-style slide)
-- ═══════════════════════════════════════════════════════════════════
function Nova:Tab(name)
    local tab = { Name = name }

    local btn = new("TextButton", {
        Size = UDim2.new(0, 88, 0, 32),
        BackgroundColor3 = Nova.Theme.card,
        BackgroundTransparency = 1,
        Text = name, TextColor3 = Nova.Theme.sub,
        TextSize = 10, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, AutoButtonColor = false,
        ZIndex = 3, Parent = self.TabRail
    })
    round(btn, Nova.Theme.radius - 6)

    local page = new("Frame", {
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false, Parent = self.Content
    })
    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6), Parent = page
    })

    tab.Button = btn
    tab.Page = page

    btn.Activated:Connect(function() self:Pick(tab) end)
    table.insert(self.Tabs, tab)
    if not self.Active then self:Pick(tab) end
    return tab
end

function Nova:Pick(tab)
    if self.Active == tab then return end
    for _, t in ipairs(self.Tabs) do
        t.Page.Visible = false
        anim(t.Button, 0.2, { TextColor3 = Nova.Theme.sub }):Play()
    end
    tab.Page.Visible = true
    anim(tab.Button, 0.2, { TextColor3 = Nova.Theme.accent }):Play()

    -- slide pill to button
    pop(self.Pill, {
        Position = UDim2.new(0, tab.Button.AbsolutePosition.X - self.Rail.AbsolutePosition.X - 2, 0.5, -17),
        Size = UDim2.new(0, tab.Button.AbsoluteSize.X, 0, 34)
    }, 0.35):Play()

    self.Active = tab
end

-- ═══════════════════════════════════════════════════════════════════
--                     Elements
-- ═══════════════════════════════════════════════════════════════════
local function stagger(parent, idx)
    -- Jily-style entrance
    parent.Position = UDim2.new(0, 20, 0, parent.Position.Y.Offset)
    parent.BackgroundTransparency = 1
    task.delay(idx * 0.03, function()
        pop(parent, { Position = UDim2.new(0, 0, 0, 0),
                      BackgroundTransparency = 0 }, 0.4):Play()
    end)
end

function Nova:Section(tab, text)
    return new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "✦ " .. text:upper(),
        TextColor3 = Nova.Theme.accent,
        TextSize = 10, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
end

function Nova:Label(tab, text)
    local l = new("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundColor3 = Nova.Theme.card,
        BackgroundTransparency = 0.4,
        Text = "  " .. text, TextColor3 = Nova.Theme.sub,
        TextSize = 10, Font = Enum.Font.Gotham,
        BorderSizePixel = 0, TextXAlignment = Enum.TextXAlignment.Left,
        Parent = tab.Page
    })
    round(l, Nova.Theme.radius - 6)
    return l
end

function Nova:Button(tab, label, cb, color)
    color = color or Nova.Theme.accent
    local b = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 36),
        BackgroundColor3 = color,
        Text = label, TextColor3 = Nova.Theme.bg,
        TextSize = 11, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, AutoButtonColor = false, Parent = tab.Page
    })
    round(b, Nova.Theme.radius - 4)
    stagger(b, #Nova.Items)

    b.MouseEnter:Connect(function()
        anim(b, 0.15, {
            Size = UDim2.new(1, 0, 0, 38),
            Position = UDim2.new(0, 0, 0, -1),
            BackgroundColor3 = color:Lerp(Color3.new(1, 1, 1), 0.15)
        }):Play()
    end)
    b.MouseLeave:Connect(function()
        anim(b, 0.15, {
            Size = UDim2.new(1, 0, 0, 36),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundColor3 = color
        }):Play()
    end)
    b.Activated:Connect(function()
        ripple(b, Nova.Theme.bg)
        if cb then pcall(cb) end
    end)

    local item = { SetEnabled = function(s) b.Active = s; b.BackgroundTransparency = s and 0 or 0.5 end }
    table.insert(Nova.Items, item)
    return item
end

function Nova:Toggle(tab, label, default, flag, cb)
    local state = default or false
    local item = { flag = flag }

    local c = new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Nova.Theme.card,
        BorderSizePixel = 0, Parent = tab.Page
    })
    round(c, Nova.Theme.radius - 4)
    stagger(c, #Nova.Items)

    new("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = Nova.Theme.text, TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = c
    })

    local sw = new("Frame", {
        Size = UDim2.new(0, 36, 0, 20),
        Position = UDim2.new(1, -46, 0.5, -10),
        BackgroundColor3 = state and Nova.Theme.accent or Nova.Theme.bg,
        BorderSizePixel = 0, Parent = c
    })
    round(sw, 10)
    outline(sw, state and Nova.Theme.accent or Nova.Theme.sub, 1, 0.4)

    local knob = new("Frame", {
        Size = UDim2.new(0, 16, 0, 16),
        Position = state and UDim2.new(0, 18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, Parent = sw
    })
    round(knob, 8)

    local hit = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = "", Active = true, Parent = c
    })

    local function set(v)
        state = v
        anim(sw, 0.25, {
            BackgroundColor3 = state and Nova.Theme.accent or Nova.Theme.bg
        }):Play()
        pop(knob, {
            Position = state and UDim2.new(0, 18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        }, 0.3):Play()
        if flag then Nova.Flags[flag] = state end
        if cb then pcall(cb, state) end
    end

    hit.Activated:Connect(function() set(not state) end)

    item.Set = set
    item.Get = function() return state end
    table.insert(Nova.Items, item)
    return item
end

function Nova:Slider(tab, label, min, max, default, flag, cb)
    min = min or 0; max = max or 100
    default = math.clamp(default or min, min, max)
    local state = default
    local item = { flag = flag }

    local c = new("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Nova.Theme.card,
        BorderSizePixel = 0, Parent = tab.Page
    })
    round(c, Nova.Theme.radius - 4)
    stagger(c, #Nova.Items)

    new("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 16),
        Position = UDim2.new(0, 12, 0, 6),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = Nova.Theme.text, TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = c
    })

    local val = new("TextLabel", {
        Size = UDim2.new(0, 50, 0, 16),
        Position = UDim2.new(1, -62, 0, 6),
        BackgroundTransparency = 1, Text = tostring(state),
        TextColor3 = Nova.Theme.accent, TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = c
    })

    local barBg = new("Frame", {
        Size = UDim2.new(1, -24, 0, 14),
        Position = UDim2.new(0, 12, 0, 28),
        BackgroundColor3 = Nova.Theme.bg,
        BorderSizePixel = 0, Parent = c
    })
    round(barBg, 7)

    local fill = new("Frame", {
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundColor3 = Nova.Theme.accent,
        BorderSizePixel = 0, Parent = barBg
    })
    round(fill, 7)

    local knob = new("Frame", {
        Size = UDim2.new(0, 20, 0, 14),
        Position = UDim2.new(0, -10, 0, 0),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0, ZIndex = 2, Parent = barBg
    })
    round(knob, 7)
    outline(knob, Nova.Theme.accent, 1)

    local hit = new("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1, Text = "",
        ZIndex = 3, Active = true, Parent = barBg
    })

    local function set(v)
        v = math.clamp(v, min, max)
        local r = (v - min) / (max - min)
        state = math.floor(v * 100 + 0.5) / 100
        fill.Size = UDim2.new(r, 0, 1, 0)
        knob.Position = UDim2.new(r, -10, 0, 0)
        val.Text = tostring(state)
        if flag then Nova.Flags[flag] = state end
        if cb then pcall(cb, state) end
    end

    local function fromX(x)
        local r = math.clamp((x - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X, 0, 1)
        set(min + (max - min) * r)
    end

    local drag = false
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; fromX(i.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement
        or i.UserInputType == Enum.UserInputType.Touch) then
            fromX(i.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then drag = false end
    end)

    set(default)
    item.Set = set
    item.Get = function() return state end
    table.insert(Nova.Items, item)
    return item
end

function Nova:Dropdown(tab, label, options, default, flag, cb)
    options = options or {}
    local sel = default or options[1]
    local item = { flag = flag, value = sel }
    local open = false

    local c = new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Nova.Theme.card,
        BorderSizePixel = 0, ClipsDescendants = true, Parent = tab.Page
    })
    round(c, Nova.Theme.radius - 4)
    stagger(c, #Nova.Items)

    local head = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 1, Text = "", Active = true, Parent = c
    })

    new("TextLabel", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = Nova.Theme.text, TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = head
    })

    local selL = new("TextLabel", {
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(1, -120, 0, 0),
        BackgroundTransparency = 1, Text = sel,
        TextColor3 = Nova.Theme.accent, TextSize = 10,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Right, Parent = head
    })

    new("TextLabel", {
        Size = UDim2.new(0, 20, 1, 0),
        Position = UDim2.new(1, -22, 0, 0),
        BackgroundTransparency = 1, Text = "▾",
        TextColor3 = Nova.Theme.sub, TextSize = 11,
        Font = Enum.Font.GothamBold, Parent = head
    })

    local list = new("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 34),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = c
    })
    new("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 2), Parent = list
    })

    local function refresh()
        for _, ch in ipairs(list:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end
        for _, o in ipairs(options) do
            local b = new("TextButton", {
                Size = UDim2.new(1, 0, 0, 24),
                BackgroundColor3 = o == sel and Nova.Theme.accent or Nova.Theme.bg,
                Text = o,
                TextColor3 = o == sel and Nova.Theme.bg or Nova.Theme.text,
                TextSize = 10, Font = Enum.Font.Gotham,
                BorderSizePixel = 0, Parent = list
            })
            round(b, 4)
            b.Activated:Connect(function()
                sel = o; item.value = o; selL.Text = o
                if flag then Nova.Flags[flag] = o end
                if cb then pcall(cb, o) end
                refresh()
            end)
        end
    end
    refresh()

    head.Activated:Connect(function()
        open = not open
        local target = open and (34 + math.min(#options * 26, 120)) or 34
        pop(c, { Size = UDim2.new(1, 0, 0, target) }, 0.35):Play()
    end)

    item.Set = function(v) sel = v; item.value = v; selL.Text = v; refresh() end
    item.Get = function() return sel end
    table.insert(Nova.Items, item)
    return item
end

function Nova:Textbox(tab, label, placeholder, default, flag, cb)
    local item = { flag = flag }

    local c = new("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = Nova.Theme.card,
        BorderSizePixel = 0, Parent = tab.Page
    })
    round(c, Nova.Theme.radius - 4)
    stagger(c, #Nova.Items)

    new("TextLabel", {
        Size = UDim2.new(1, -20, 0, 14),
        Position = UDim2.new(0, 12, 0, 5),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = Nova.Theme.sub, TextSize = 9,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = c
    })

    local b = new("TextBox", {
        Size = UDim2.new(1, -24, 0, 24),
        Position = UDim2.new(0, 12, 0, 20),
        BackgroundColor3 = Nova.Theme.bg,
        Text = default or "", PlaceholderText = placeholder or "",
        PlaceholderColor3 = Nova.Theme.sub,
        TextColor3 = Nova.Theme.text, TextSize = 10,
        Font = Enum.Font.Gotham, BorderSizePixel = 0,
        ClearTextOnFocus = false, Parent = c
    })
    round(b, 6)
    new("UIPadding", { PaddingLeft = UDim.new(0, 8), Parent = b })

    b.FocusLost:Connect(function()
        if flag then Nova.Flags[flag] = b.Text end
        if cb then pcall(cb, b.Text) end
    end)

    item.Set = function(v) b.Text = tostring(v) end
    item.Get = function() return b.Text end
    table.insert(Nova.Items, item)
    return item
end

function Nova:Keybind(tab, label, default, flag, cb)
    local item = { flag = flag, key = default or Enum.KeyCode.E }

    local c = new("Frame", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = Nova.Theme.card,
        BorderSizePixel = 0, Parent = tab.Page
    })
    round(c, Nova.Theme.radius - 4)
    stagger(c, #Nova.Items)

    new("TextLabel", {
        Size = UDim2.new(0.6, 0, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = Nova.Theme.text, TextSize = 10,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = c
    })

    local kb = new("TextButton", {
        Size = UDim2.new(0, 76, 0, 24),
        Position = UDim2.new(1, -88, 0.5, -12),
        BackgroundColor3 = Nova.Theme.bg,
        Text = item.key.Name, TextColor3 = Nova.Theme.accent,
        TextSize = 9, Font = Enum.Font.GothamBold,
        BorderSizePixel = 0, Parent = c
    })
    round(kb, 6)
    outline(kb, Nova.Theme.accent, 1)

    local listening = false
    kb.Activated:Connect(function()
        listening = true; kb.Text = "..."
    end)

    UserInputService.InputBegan:Connect(function(inp, gp)
        if listening and not gp and inp.UserInputType == Enum.UserInputType.Keyboard then
            item.key = inp.KeyCode
            kb.Text = inp.KeyCode.Name
            listening = false
            if flag then Nova.Flags[flag] = inp.KeyCode.Name end
        elseif inp.KeyCode == item.key and not gp then
            if cb then pcall(cb) end
        end
    end)

    table.insert(Nova.Items, item)
    return item
end

_G.NovaUI_Loaded = Nova
return Nova
