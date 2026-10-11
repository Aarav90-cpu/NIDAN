# ADR 011: Curated Lightweight XFCE Student Desktop Environment with Supervised Application Control

## Context

Prior to this decision, NIDAN OS booted into a single-application Wayland kiosk (`cage` + `chromium`) that exclusively displayed the NIDAN web platform.

While the kiosk model prevents distraction, it introduced significant drawbacks for real-world classroom education:
1. Students need access to standard productivity tools (word processing, spreadsheets, presentations via LibreOffice), offline reference documentation, and file management.
2. Implementing office suite editors and document viewers directly inside NIDAN would require massive development effort and duplicate mature open-source tools.
3. Full desktop environments like GNOME Shell and GDM are resource-heavy: they require `elogind`, `polkit`, high GPU acceleration, 2+ GB RAM at idle, and expand the ISO beyond 2.5 GB. This conflicts with [ADR 009](009-switch-to-alpine-linux.md) for low-spec T1 student hardware.

## Decision

We adopt a customized, lightweight **XFCE desktop environment** on Alpine Linux with the following specifications:

1. **Lightweight Base**:
   - XFCE provides a responsive desktop using under 400 MB RAM at idle while keeping the overall ISO under 1 GB.
   - Runs natively on Alpine Linux with OpenRC without complex systemd dependencies.

2. **Curated Applications**:
   - **NIDAN Platform**: Auto-launches on login in maximized application window.
   - **LibreOffice Suite**: Writer, Calc, Impress pre-installed for offline schoolwork.
   - **Chromium**: Available for local resources and approved educational material.
   - **Thunar**: Simple file management for student assignments and exports.

3. **Elevated User Experience**:
   - Modern Libadwaita dark theme via `adw-gtk3` (`adw-gtk3-dark`), full icon coverage with `adwaita-xfce-icon-theme`, and window manager border themes via `xfwm4-themes`.
   - High-contrast anti-aliased typography (`DejaVu Sans`), and xfwm4 hardware compositing enabled for clean window shadows, rounded aesthetics, and smooth transitions.
   - Clean, centered bottom dock/panel pinned with educational tools.

4. **Student Lockdown & Supervised Application Control**:
   - The student account (`student`) operates with unprivileged rights and no `sudo` access.
   - Package manager execution (`/sbin/apk`) is restricted to root (`chmod 0750 /sbin/apk`), preventing unauthorized command-line software changes.
   - Package managers and software store interfaces are omitted from user menus.
   - Software updates and new application requests are coordinated through the NIDAN platform:
     - System updates are triggered via the NIDAN UI.
     - Application install requests are submitted by students to teachers via NIDAN; upon teacher approval, the installation command is dispatched to the device.

## Consequences

### Positive
- Students gain access to production-grade office tools (LibreOffice) without reinventing office suites.
- Maintains high performance on low-spec hardware (1-2 GB RAM T1 devices).
- Protects student devices from arbitrary software installation or tampering.
- Keeps classroom management under teacher supervision.

### Negative / Trade-offs
- The base ISO size increases by ~250 MB due to LibreOffice and XFCE packages compared to the bare Cage kiosk.
- Requires maintaining XFCE panel and theme configuration scripts in the OS overlay generator.
