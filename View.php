<?php
declare(strict_types=1);

/**
 * View — minimal server-side rendering helpers (no template engine).
 * Emits CSP-friendly markup: external app.css + Google Fonts via <link>,
 * no inline styles or scripts.
 */
final class View
{
    /**
     * Inline SVG ikony pro boční panel (CSP-safe: prezentační atributy, žádný style=).
     * stroke="currentColor" → dědí barvu z .adm-side-link (mění se hover/active).
     */
    private static function navIcon(string $key): string
    {
        $paths = [
            'overview'   => '<rect x="3" y="3" width="7" height="7" rx="1"/><rect x="14" y="3" width="7" height="7" rx="1"/><rect x="14" y="14" width="7" height="7" rx="1"/><rect x="3" y="14" width="7" height="7" rx="1"/>',
            'products'   => '<path d="M21 8a2 2 0 0 0-1-1.73l-7-4a2 2 0 0 0-2 0l-7 4A2 2 0 0 0 3 8v8a2 2 0 0 0 1 1.73l7 4a2 2 0 0 0 2 0l7-4A2 2 0 0 0 21 16Z"/><path d="m3.3 7 8.7 5 8.7-5"/><path d="M12 22V12"/>',
            'ordering'   => '<line x1="9" y1="6" x2="21" y2="6"/><line x1="9" y1="12" x2="21" y2="12"/><line x1="9" y1="18" x2="21" y2="18"/><path d="M4 6h1v4"/><path d="M4 10h2"/><path d="M6 18H4c0-1 2-1.4 2-2.5S5 14 4 14.5"/>',
            'categories' => '<path d="M4 20h16a2 2 0 0 0 2-2V8a2 2 0 0 0-2-2h-7.9a2 2 0 0 1-1.7-.9l-.8-1.2A2 2 0 0 0 8 3H4a2 2 0 0 0-2 2v13c0 1.1.9 2 2 2Z"/>',
            'agencies'   => '<rect x="4" y="2" width="16" height="20" rx="2"/><path d="M9 22v-4h6v4"/><path d="M8 6h.01"/><path d="M16 6h.01"/><path d="M8 10h.01"/><path d="M16 10h.01"/><path d="M8 14h.01"/><path d="M16 14h.01"/>',
            'schedules'  => '<path d="M21 8V6a2 2 0 0 0-2-2H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h6"/><path d="M16 2v4M8 2v4M3 10h18"/><circle cx="18" cy="18" r="4"/><path d="M18 16.5V18l1 1"/>',
            'sellers'    => '<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.1a4 4 0 0 1 0 7.75"/>',
            'reports'    => '<line x1="12" y1="20" x2="12" y2="10"/><line x1="18" y1="20" x2="18" y2="4"/><line x1="6" y1="20" x2="6" y2="16"/><line x1="3" y1="20" x2="21" y2="20"/>',
            'admins'     => '<path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10Z"/>',
        ];
        $inner = $paths[$key] ?? '<circle cx="12" cy="12" r="9"/>';
        return '<svg class="adm-side-ic" width="18" height="18" viewBox="0 0 24 24" fill="none"'
            . ' stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">'
            . $inner . '</svg>';
    }

    /**
     * Admin boční panel. $active = klíč aktuální stránky.
     * $opts: ['actor' => array (patička s uživatelem), 'badges' => [key => int] (počty)].
     * Volání s jedním argumentem zůstává plně funkční (zpětně kompatibilní).
     */
    public static function adminNav(string $active, array $opts = []): string
    {
        $badges = (array) ($opts['badges'] ?? []);
        $actor  = $opts['actor'] ?? null;
        $groups = [
            '' => [
                'overview'   => ['/admin/', 'Přehled'],
            ],
            'Katalog' => [
                'products'   => ['/admin/products.php', 'Produkty'],
                'ordering'   => ['/admin/ordering.php', 'Pořadí'],
                'categories' => ['/admin/categories.php', 'Kategorie'],
                'agencies'   => ['/admin/agencies.php', 'Agentury'],
                'schedules'  => ['/admin/schedules.php', 'Rozvrhy'],
            ],
            'Provoz' => [
                'sellers'    => ['/admin/sellers.php', 'Prodejci'],
                'reports'    => ['/admin/reports.php', 'Reporty'],
            ],
            'Systém' => [
                'admins'     => ['/admin/admins.php', 'Admini'],
            ],
        ];
        $html = '<aside class="adm-side">'
            . '<div class="adm-side-brand"><span class="adm-side-mark">PTI</span><span class="adm-side-brand-t">Admin</span></div>'
            . '<nav class="adm-side-nav">';
        foreach ($groups as $label => $items) {
            if ($label !== '') { $html .= '<div class="adm-side-group-l">' . e($label) . '</div>'; }
            foreach ($items as $key => [$href, $text]) {
                $cls = $key === $active ? 'adm-side-link active' : 'adm-side-link';
                $badge = '';
                if (isset($badges[$key]) && (int) $badges[$key] > 0) {
                    $badge = '<span class="adm-side-badge">' . (int) $badges[$key] . '</span>';
                }
                $html .= '<a class="' . $cls . '" href="' . e($href) . '">'
                    . self::navIcon($key)
                    . '<span class="adm-side-tx">' . e($text) . '</span>'
                    . $badge
                    . '</a>';
            }
        }
        $html .= '</nav>';
        if (is_array($actor)) {
            $initial = mb_strtoupper(mb_substr((string) ($actor['name'] ?? '?'), 0, 1));
            $html .= '<div class="adm-side-foot">'
                . '<span class="adm-side-foot-av">' . e($initial) . '</span>'
                . '<span class="adm-side-foot-b">'
                . '<span class="adm-side-foot-n">' . e((string) ($actor['name'] ?? '')) . '</span>'
                . '<span class="adm-side-foot-r">' . e((string) ($actor['role'] ?? 'admin')) . '</span>'
                . '</span></div>';
        }
        return $html . '</aside>';
    }

    /** Full HTML document head + open body. */
    private static function head(string $title, array $opts = []): string
    {
        $js = $opts['js'] ?? false;
        $jsTag = $js ? '<script src="/assets/app.js" defer></script>' : '';
        return '<!doctype html><html lang="cs"><head><meta charset="utf-8">'
            . '<meta name="viewport" content="width=device-width, initial-scale=1">'
            . '<meta name="robots" content="noindex, nofollow">'
            . '<title>' . e($title) . ' · PTI</title>'
            . '<link rel="preconnect" href="https://fonts.googleapis.com">'
            . '<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>'
            . '<link href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,350;0,9..144,400;0,9..144,500;1,9..144,400&family=Manrope:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500;700&display=swap" rel="stylesheet">'
            . '<link rel="stylesheet" href="/assets/app.css">'
            . $jsTag
            . '</head><body>';
    }

    /** A centered login-style page (no topbar). */
    public static function login(string $title, string $inner, array $opts = []): never
    {
        header('Content-Type: text/html; charset=utf-8');
        echo self::head($title, $opts)
            . '<div class="login">' . $inner . '</div>'
            . '</body></html>';
        exit;
    }

    /** A logged-in page with the topbar shell. */
    public static function shell(string $title, array $actor, string $body, array $opts = []): never
    {
        $tenantName = $opts['tenant'] ?? null;
        $tenantChip = $tenantName
            ? '<span class="tenant-chip">' . e($tenantName) . '</span>' : '';
        $initial = mb_strtoupper(mb_substr($actor['name'] ?? '?', 0, 1));
        $logout = $opts['logout'] ?? '/?action=logout';

        header('Content-Type: text/html; charset=utf-8');
        $isAdmin = ($opts['subtitle'] ?? '') === 'administrace';
        echo self::head($title, $opts)
            . '<header class="topbar">'
            . '<span class="logo"><span class="logo-mark">PTI</span> Prague Tourist Info'
            . '<span class="logo-sub">' . e($opts['subtitle'] ?? '') . '</span></span>'
            . $tenantChip
            . '<span class="spacer"></span>'
            . (($actor['type'] ?? '') === 'station' ? '<a class="btn-g" href="/shift.php" title="Dnešní tržba a bonus">Moje směna</a>' : '')
            . '<a class="user" href="/sales.php" title="Přehled prodejů a voucherů"><span class="user-av">' . e($initial) . '</span>'
            . '<span class="user-name">' . e($actor['name'] ?? '') . '</span>'
            . '<span class="user-role">' . e($actor['role'] ?? '') . '</span></a>'
            . '<a class="btn-g" href="' . e($logout) . '">Odhlásit</a>'
            . '</header>'
            . '<main class="wrap' . ($isAdmin ? ' wrap--admin' : '') . '">' . $body . '</main>'
            . '</body></html>';
        exit;
    }
}
