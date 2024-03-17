variable "automanage_configurations" {
  description = "The automanage configurations to be deployed"
  type = list(object({
    name                        = string
    rg_name                     = string
    location                    = optional(string, "uksouth")
    tags                        = map(string)
    automation_account_enabled  = optional(bool)
    boot_diagnostics_enabled    = optional(bool)
    defender_for_cloud_enabled  = optional(bool)
    guest_configuration_enabled = optional(bool)
    log_analytics_enabled       = optional(bool)
    status_change_alert_enabled = optional(bool)
    antimalware = optional(object({
      real_time_protection_enabled   = optional(bool)
      scheduled_scan_enabled         = optional(bool)
      scheduled_scan_type            = optional(string)
      scheduled_scan_day             = optional(number)
      scheduled_scan_time_in_minutes = optional(number)
      exclusions = optional(object({
        extensions = optional(string)
        paths      = optional(string)
        processes  = optional(string)
      }))
    }))
    azure_security_baseline = optional(object({
      assignment_type = optional(string)
    }))
    backup = optional(object({
      policy_name                  = optional(string)
      time_zone                    = optional(string)
      instant_rp_retention_in_days = optional(number)
      schedule_policy = optional(object({
        schedule_run_frequency = optional(string)
        schedule_run_times     = optional(list(string))
        schedule_run_days      = optional(list(string))
        schedule_policy_type   = optional(string)
      }))
      retention_policy = optional(object({
        retention_policy_type = optional(string)
        daily_schedule = optional(object({
          retention_times = optional(list(string))
          retention_duration = optional(object({
            count         = optional(number)
            duration_type = optional(string)
          }))
        }))
        weekly_schedule = optional(object({
          retention_times = optional(list(string))
          retention_duration = optional(object({
            count         = optional(number)
            duration_type = optional(string)
          }))
        }))
      }))
    }))
  }))
}
