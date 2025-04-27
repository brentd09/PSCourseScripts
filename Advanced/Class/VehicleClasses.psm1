class Engine {
    [string]$Type
    [int]$HorsePower

    Engine([string]$type, [int]$horsePower) {
        $this.Type = $type
        $this.HorsePower = $horsePower
    }
}

class Vehicle {
    [string]$Make
    [string]$Model
    [int]$Year
    [Engine]$Engine

    Vehicle([string]$make, [string]$model, [int]$year, [Engine]$engine) {
        $this.Make = $make
        $this.Model = $model
        $this.Year = $year
        $this.Engine = $engine
    }

    [void]DisplayInfo() {
        Write-Host "Make: $($this.Make)"
        Write-Host "Model: $($this.Model)"
        Write-Host "Year: $($this.Year)"
        Write-Host "Engine Type: $($this.Engine.Type)"
        Write-Host "Horse Power: $($this.Engine.HorsePower)"
    }
}