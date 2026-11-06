 function-Функции

NewUp UI Library v13 — README
NewUp UI Library v13 — лёгкая библиотека пользовательского интерфейса для Roblox с 10 готовыми темами и плавными анимациями кнопок (Ripple + Flash), перетаскиваемым и ресайзабельным окном. API построен по иерархии Library → Window → Tab → Section → элементы.

Установка:

lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/brownik87-arch/NewUpLib/refs/heads/main/NewUpLib.lua"))()
Создать окно библиотеки — возвращает объект Window, где первый аргумент — заголовок окна, второй — стартовая тема:

lua
local Window = Library.CreateLib("My UI", "Tem1")
Сменить тему всего окна — принимает имя темы строкой:

Темы Tem:
Tem1 Фиолетовый
Tem2 Синий
Tem3 Розовый
Tem4 Зелёный
Tem5 Красный
Tem6 Оранжевый
Tem7 Бирюзовый
Tem8 Золотой
Tem9 Чёрный
Tem10 Светлый



lua
Library:SetTheme("Tem7")
Уничтожить библиотеку целиком — удаляет весь ScreenGui:

lua
Library:Destroy()
⚠️ В конце скрипта вызывается Library:Notify(...), но сама функция Notify в коде отсутствует — это заглушка/баг. Если нужны уведомления, её нужно реализовать отдельно.

Доступные темы: Tem1 (Фиолет), Tem2 (Синий), Tem3 (Розовый), Tem4 (Зелёный), Tem5 (Красный), Tem6 (Оранжевый), Tem7 (Бирюзовый), Tem8 (Золотой), Tem9 (Чёрный), Tem10 (Светлый). Плюс алиасы RJTheme1→Tem1, RJTheme2→Tem2, RJTheme3→Tem3, RJTheme4→Tem4.

Установить размер окна — принимает строку "ШxВ" или одно число (квадрат):

lua
Window.Size("600x450")
Window.Size(500)
Сменить тему конкретного окна — то же самое, что Library:SetTheme, но из контекста окна:

lua
Window:SetTheme("Tem3")
Создать вкладку (таб) — возвращает объект Tab, первая созданная вкладка автоматически выбирается активной:

lua
local Tab = Window:NewTab("Main")
Скрыть/показать окно — с анимацией масштабирования, также работает по клавише RightShift:

lua
Window:Toggle()
Уничтожить окно — удаляет всё вместе с ScreenGui:

lua
Window:Destroy()
Изменить размер из контекста вкладки — проксирует вызов в Window.Size:

lua
Tab.Size("700x500")
Создать секцию — возвращает объект Section, внутри которого добавляются все элементы:

lua
local Section = Tab:NewSection("Основное")
Создать кнопку — с Ripple- и Flash-анимацией. Первый аргумент — название, второй — описание (опционально, влияет на высоту: 34 или 46 px), третий — колбэк, вызываемый по клику (обёрнут в pcall):

lua
Section:NewButton("Привет", "Печатает в консоль", function()
    print("Hello from NewUp")
end)
Создать переключатель (Toggle) — с плавной анимацией ползунка и ripple-эффектом. Колбэк получает булево состояние true/false:

lua
Section:NewToggle("Infinite Jump", "Бесконечный прыжок", function(state)
    print("InfJump:", state)
end)
Создать слайдер — параметры: заголовок, описание, максимум, минимум, колбэк. Колбэк получает округлённое целое число, вызывается при каждом изменении. По умолчанию maxV=100, minV=0:

lua
Section:NewSlider("WalkSpeed", "Скорость ходьбы", 200, 16, function(value)
    local hum = game.Players.LocalPlayer.Character
        and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = value end
end)
Создать текстовый лейбл — неинтерактивная подпись внутри секции (цвет subtext, шрифт Gotham, размер 12):

lua
Section:NewLabel("Добро пожаловать в NewUp UI v13")
Сводка API: Library содержит CreateLib(name, themeName) → Window, SetTheme(name), Destroy(); Window содержит IsOpen (property), Size(str|number), SetTheme(name), NewTab(name) → Tab, Toggle(), Destroy(); Tab содержит Size(str), NewSection(name) → Section; Section содержит NewButton(text, desc, callback), NewToggle(text, desc, callback), NewSlider(text, desc, maxV, minV, callback), NewLabel(text).

Полный пример:

lua
local Library = loadstring(game:HttpGet("ССЫЛКА_НА_СКРИПТ"))()

local Window = Library.CreateLib("NewUp Demo", "Tem1")
Window.Size("600x450")

local Tab = Window:NewTab("Main")
local Section = Tab:NewSection("Основное")

Section:NewLabel("Добро пожаловать в NewUp UI v13")

Section:NewButton("Привет", "Печатает сообщение в консоль", function()
    print("Hello from NewUp")
end)

Section:NewToggle("Infinite Jump", "Бесконечный прыжок", function(state)
    print("InfJump:", state)
end)

Section:NewSlider("WalkSpeed", "Скорость ходьбы", 200, 16, function(v)
    local hum = game.Players.LocalPlayer.Character
        and game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = v end
end)

Window:SetTheme("Tem7")
Window:Toggle()
-- Window:Destroy()
Особенности: все кнопки и переключатели используют Ripple (круг от точки клика, TweenService, Quad Out) и Flash (кратковременная смена цвета на акцентную), ripple автоматически уничтожается через task.delay; все колбэки обёрнуты в pcall, ошибки выводятся через warn с префиксом [NewUp], поэтому одна упавшая функция не сломает UI; темы применяются динамически через themeRegistry, куда при создании каждого элемента пишется запись {inst, prop, role}; окно имеет IgnoreGuiInset = true, ResetOnSpawn = false, родитель — CoreGui (при отсутствии доступа — PlayerGui), старая копия NewUpLibrary при загрузке автоматически уничтожается; RightShift — стандартный хоткей скрытия/показа окна; функция Notify декларируется как вызов, но не реализована, поэтому всплывающие уведомления на данный момент отсутствуют.
