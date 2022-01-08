Describe 'Get-ConnectionString.Tests' {
    It 'passes default PSScriptAnalyzer rules' {
        $ModuleScriptPath = "$($PSCommandPath.Substring(0, $PSCommandPath.IndexOf('.'))).ps1"
        Invoke-ScriptAnalyzer -Path $ModuleScriptPath | Should -BeNullOrEmpty
    }
    It 'passes no params' {
        $ModuleScriptPath = "$($PSCommandPath.Substring(0, $PSCommandPath.IndexOf('.'))).ps1"
        {. $ModuleScriptPath -Verbose } | Should -Not -BeNullOrEmpty
    }
    It 'passes database' {
        $ModuleScriptPath = "$($PSCommandPath.Substring(0, $PSCommandPath.IndexOf('.'))).ps1"
        {. $ModuleScriptPath -database master -Verbose} | Should -Not -BeNullOrEmpty
    }
    It 'passes bad file' {
        $ModuleScriptPath = "$($PSCommandPath.Substring(0, $PSCommandPath.IndexOf('.'))).ps1"
        {. $ModuleScriptPath App_Config/bad.config smoke -Verbose} | Should -Throw
    }
    It 'passes bad folder' {
        $ModuleScriptPath = "$($PSCommandPath.Substring(0, $PSCommandPath.IndexOf('.'))).ps1"
        {. $ModuleScriptPath App_Config/badfolder smoke -Verbose} | Should -Throw
    }
    It 'passes good file' {
        $ModuleScriptPath = "$($PSCommandPath.Substring(0, $PSCommandPath.IndexOf('.'))).ps1"
        {. $ModuleScriptPath . smoke -Verbose} | Should -Not -BeNullOrEmpty
    }
    It 'passes bad name' {
        $ModuleScriptPath = "$($PSCommandPath.Substring(0, $PSCommandPath.IndexOf('.'))).ps1"
        {. $ModuleScriptPath . smoke -Verbose} | Should -Throw
    }
}