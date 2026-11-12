# Adaptations - Prometheus Lab 11 - Set Up Alerts in Prometheus
Everything ran for real (systemd services, Postfix local delivery, real CPU load, real firing, real mail).
- HighCPUUsage threshold: lab 80%. Measured CPU under full shell-loop load on this VM: 100.0% (idle 96.4%).
  Adapted: no -> threshold used 80% with the lab's for: 2m (lab version kept as etc/cpu_alerts.lab.yml).
- scrape/evaluation interval 5s (lab leaves them open) so the 5-minute lab budget covers for: 2m plus group_wait.
