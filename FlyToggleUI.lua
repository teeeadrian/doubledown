
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local flying = false
local speed = 100

-- 飞行控制函数
local function startFlying()
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.P = 9e4
    bodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.cframe = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.velocity = Vector3.new(0, 0, 0)
    bodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.Parent = humanoidRootPart

    RunService:BindToRenderStep("FlightControl", Enum.RenderPriority.Character.Value, function()
        local camCF = workspace.CurrentCamera.CFrame
        local moveVec = Vector3.new(0, 0, 0)

        if UIS:IsKeyDown(Enum.KeyCode.W) then moveVec += camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then moveVec -= camCF.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then moveVec -= camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then moveVec += camCF.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then moveVec += camCF.UpVector end
        if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then moveVec -= camCF.UpVector end

        bodyVelocity.velocity = moveVec.Magnitude > 0 and moveVec.Unit * speed or Vector3.new(0, 0, 0)
        bodyGyro.CFrame = camCF
    end)
end

local function stopFlying()
    RunService:UnbindFromRenderStep("FlightControl")
    for _, v in pairs(humanoidRootPart:GetChildren()) do
        if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
            v:Destroy()
        end
    end
end

-- 开关飞行的函数
local function toggleFlight()
    flying = not flying
    if flying then
        startFlying()
    else
        stopFlying()
    end
end

-- 假设这里是你之前的 UI 代码片段，focus在 ContentFrame 部分，添加按钮：

local function createButton(text, parent, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(0, 200, 0, 40)
    btn.Position = UDim2.new(0, 20, 0, 20) -- 你可根据布局调整位置
    btn.BackgroundColor3 = Color3.fromRGB(255, 245, 230)
    btn.TextColor3 = Color3.fromRGB(60, 40, 20)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.Text = text
    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 8)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- 给 ContentFrame 添加飞行开关按钮
local flyButton = createButton("飞行开关", ContentFrame, toggleFlight)
