```hcl
resource "azurerm_automanage_configuration" "automanage_configs" {
  for_each                    = { for k, v in var.automanage_configurations : k => v }
  name                        = each.value.name
  resource_group_name         = each.value.rg_name
  location                    = each.value.location
  tags                        = each.value.tags
  automation_account_enabled  = each.value.automation_account_enabled
  boot_diagnostics_enabled    = each.value.boot_diagnostics_enabled
  defender_for_cloud_enabled  = each.value.defender_for_cloud_enabled
  guest_configuration_enabled = each.value.guest_configuration_enabled
  log_analytics_enabled       = each.value.log_analytics_enabled
  status_change_alert_enabled = each.value.status_change_alert_enabled

  dynamic "antimalware" {
    for_each = each.value.antimalware != null ? [each.value.antimalware] : []
    content {
      real_time_protection_enabled   = antimalware.value.real_time_protection_enabled
      scheduled_scan_enabled         = antimalware.value.scheduled_scan_enabled
      scheduled_scan_type            = antimalware.value.scheduled_scan_type
      scheduled_scan_day             = antimalware.value.scheduled_scan_day
      scheduled_scan_time_in_minutes = antimalware.value.scheduled_scan_time_in_minutes

      dynamic "exclusions" {
        for_each = antimalware.value.exclusions != null ? [antimalware.value.exclusions] : []
        content {
          extensions = exclusions.value.extensions
          paths      = exclusions.value.paths
          processes  = exclusions.value.processes
        }
      }
    }
  }

  dynamic "azure_security_baseline" {
    for_each = each.value.azure_security_baseline != null ? [each.value.azure_security_baseline] : []
    content {
      assignment_type = azure_security_baseline.value.assignment_type
    }
  }

  dynamic "backup" {
    for_each = each.value.backup != null ? [each.value.backup] : []
    content {
      policy_name                        = backup.value.policy_name
      time_zone                          = backup.value.time_zone
      instant_rp_retention_range_in_days = backup.value.instant_rp_retention_in_days

      dynamic "schedule_policy" {
        for_each = backup.value.schedule_policy != null ? [each.value.schedule_policy] : []
        content {
          schedule_run_frequency = schedule_policy.value.schedule_run_frequency
          schedule_run_times     = schedule_policy.value.schedule_run_times
          schedule_run_days      = schedule_policy.value.schedule_run_days
          schedule_policy_type   = schedule_policy.value.schedule_policy_type
        }
      }

      dynamic "retention_policy" {
        for_each = backup.value.retention_policy != null ? [each.value.retention_policy] : []
        content {

          retention_policy_type = retention_policy.value.retention_policy_type

          dynamic "daily_schedule" {
            for_each = retention_policy.value.daily_schedule != null ? [retention_policy.value.daily_schedule] : []
            content {
              retention_times = []

              dynamic "retention_duration" {
                for_each = daily_schedule.value.retention_duration != null ? [
                  daily_schedule.value.retention_duration
                ] : []
                content {
                  count         = retention_duration.value.count
                  duration_type = retention_duration.value.duration_type
                }
              }
            }
          }

          dynamic "weekly_schedule" {
            for_each = retention_policy.value.weekly_schedule != null ? [retention_policy.value.weekly_schedule] : []
            content {
              retention_times = []

              dynamic "retention_duration" {
                for_each = weekly_schedule.value.retention_duration != null ? [
                  weekly_schedule.value.retention_duration
                ] : []
                content {
                  count         = retention_duration.value.count
                  duration_type = retention_duration.value.duration_type
                }
              }
            }
          }
        }
      }
    }
  }
}
```
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_automanage_configuration.automanage_configs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automanage_configuration) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automanage_configurations"></a> [automanage\_configurations](#input\_automanage\_configurations) | The automanage configurations to be deployed | <pre>list(object({<br>    name                        = string<br>    rg_name                     = string<br>    location                    = optional(string, "uksouth")<br>    tags                        = map(string)<br>    automation_account_enabled  = optional(bool)<br>    boot_diagnostics_enabled    = optional(bool)<br>    defender_for_cloud_enabled  = optional(bool)<br>    guest_configuration_enabled = optional(bool)<br>    log_analytics_enabled       = optional(bool)<br>    status_change_alert_enabled = optional(bool)<br>    antimalware = optional(object({<br>      real_time_protection_enabled   = optional(bool)<br>      scheduled_scan_enabled         = optional(bool)<br>      scheduled_scan_type            = optional(string)<br>      scheduled_scan_day             = optional(number)<br>      scheduled_scan_time_in_minutes = optional(number)<br>      exclusions = optional(object({<br>        extensions = optional(string)<br>        paths      = optional(string)<br>        processes  = optional(string)<br>      }))<br>    }))<br>    azure_security_baseline = optional(object({<br>      assignment_type = optional(string)<br>    }))<br>    backup = optional(object({<br>      policy_name                  = optional(string)<br>      time_zone                    = optional(string)<br>      instant_rp_retention_in_days = optional(number)<br>      schedule_policy = optional(object({<br>        schedule_run_frequency = optional(string)<br>        schedule_run_times     = optional(list(string))<br>        schedule_run_days      = optional(list(string))<br>        schedule_policy_type   = optional(string)<br>      }))<br>      retention_policy = optional(object({<br>        retention_policy_type = optional(string)<br>        daily_schedule = optional(object({<br>          retention_times = optional(list(string))<br>          retention_duration = optional(object({<br>            count         = optional(number)<br>            duration_type = optional(string)<br>          }))<br>        }))<br>        weekly_schedule = optional(object({<br>          retention_times = optional(list(string))<br>          retention_duration = optional(object({<br>            count         = optional(number)<br>            duration_type = optional(string)<br>          }))<br>        }))<br>      }))<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location for this resource to be put in | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VNet gateway | `string` | n/a | yes |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | The name of the resource group, this module does not create a resource group, it is expecting the value of a resource group already exists | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of the tags to use on the resources that are deployed with this module. | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_automanage_id"></a> [automanage\_id](#output\_automanage\_id) | The id of automange config |
| <a name="output_automanage_name"></a> [automanage\_name](#output\_automanage\_name) | The name of automange config |
| <a name="output_automanage_rg_name"></a> [automanage\_rg\_name](#output\_automanage\_rg\_name) | The rg\_name of automange config |
| <a name="output_automanage_tags"></a> [automanage\_tags](#output\_automanage\_tags) | The tags of automange config |
