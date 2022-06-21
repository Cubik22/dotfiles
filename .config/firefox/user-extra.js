/*** suggested ***/

user_pref("_user.js.parrot", "suggested section syntax error");

user_pref("startup.homepage_welcome_url", "");
user_pref("startup.homepage_welcome_url.additional", "");
user_pref("startup.homepage_override_url", ""); // What's New page after updates

user_pref("browser.tabs.warnOnClose", false); // [DEFAULT false FF94+]
user_pref("browser.tabs.warnOnCloseOtherTabs", false);
user_pref("browser.tabs.warnOnOpen", false);
user_pref("browser.warnOnQuitShortcut", false); // [FF94+]
user_pref("full-screen-api.warning.delay", 0);
user_pref("full-screen-api.warning.timeout", 0);

user_pref("app.update.auto", false); // [NON-WINDOWS] disable auto app updates

user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true); // [FF68+] allow userChrome/userContent

// 0=no-preference, 1=reduce: with RFP this only affects chrome
user_pref("ui.prefersReducedMotion", 1); // disable chrome animations [FF77+] [RESTART] [HIDDEN PREF]

// 0=light, 1=dark: with RFP this only affects chrome
user_pref("ui.systemUsesDarkTheme", 1); // [FF67+] [HIDDEN PREF]

user_pref("clipboard.autocopy", false); // disable autocopy default [LINUX]

user_pref("layout.spellcheckDefault", 0); // 0=none, 1-multi-line, 2=multi-line & single-line

user_pref("browser.tabs.loadBookmarksInTabs", true); // open bookmarks in a new tab [FF57+]

user_pref("ui.key.menuAccessKey", 0); // disable alt key toggling the menu bar [RESTART]

user_pref("view_source.tab", false); // view "page/selection source" in a new window [FF68+, FF59 and under]

user_pref("browser.messaging-system.whatsNewPanel.enabled", false); // What's New toolbar icon [FF69+]

user_pref("extensions.pocket.enabled", false); // Pocket Account [FF46+]
user_pref("extensions.screenshots.disabled", true); // [FF55+]
user_pref("identity.fxaccounts.enabled", false); // Firefox Accounts & Sync [FF60+] [RESTART]
user_pref("reader.parse-on-load.enabled", false); // Reader View

// [SETTING] General>Browsing>Recommend extensions as you browse
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons", false); // disable CFR [FF67+]
// [SETTING] General>Browsing>Recommend features as you browse
user_pref("browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features", false); // disable CFR [FF67+]

/*** personal ***/

user_pref("_user.js.parrot", "personal section syntax error");

/* disable password settings */
user_pref("signon.generation.enabled", false);
user_pref("signon.management.page.breach-alerts.enabled", false);

/* mousewheel (and touchpad) sensitivity */
user_pref("mousewheel.default.delta_multiplier_x", 20);
user_pref("mousewheel.default.delta_multiplier_y", 25);
user_pref("mousewheel.default.delta_multiplier_z", 20);

/* remove picture-in-picture control */
user_pref("media.videocontrols.picture-in-picture.video-toggle.enabled", false);

/* remove title bar */
user_pref("browser.tabs.inTitlebar", 1);

/* disable tabs overflow */
user_pref("browser.tabs.tabMinWidth", 0);

/* 0 normal density (default), 1 compact density, 2 touch density */
user_pref("browser.uidensity", 1);
user_pref("browser.compactmode.show", true);

/* disable quick find with / and ' */
// user_pref("accessibility.typeaheadfind.manual", false);

/* dark theme */
user_pref("browser.theme.content-theme", 0);
user_pref("browser.theme.toolbar-theme", 0);
user_pref("extensions.activeThemeID", "firefox-compact-dark@mozilla.org");
user_pref("pdfjs.viewerCssTheme", 2);

/* disable sidebar in pdf by default */
user_pref("pdfjs.sidebarViewOnLoad", 0);

/* never show bookmarks */
user_pref("browser.toolbars.bookmarks.visibility", "never");
// user_pref("browser.toolbars.bookmarks.visibility", "always");

/* show mobile bookmarks */
// user_pref("browser.bookmarks.showMobileBookmarks", true);

/* clear new tab and home */
user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
user_pref("browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned", "");
user_pref("browser.newtabpage.activity-stream.section.highlights.includeBookmarks", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeDownloads", false);
user_pref("browser.newtabpage.activity-stream.section.highlights.includeVisited", false);
user_pref("browser.newtabpage.activity-stream.showSearch", false);

/* clear new tab pinned */
user_pref("browser.newtabpage.pinned", "[]");

/* try to change default search engine, usually requires manually setting it */
// user_pref("browser.urlbar.placeholderName", "DuckDuckGo");
// user_pref("browser.urlbar.placeholderName.private", "DuckDuckGo");

/* do not show search suggestions ahead of browsing history in address bar results */
user_pref("browser.urlbar.showSearchSuggestionsFirst", false);

/* remove more from mozilla page in preferences */
user_pref("browser.preferences.moreFromMozilla", false);

/* fully disable autoplay */
user_pref("media.autoplay.block-webaudio", true);
user_pref("media.autoplay.block-event.enabled", true);
user_pref("media.autoplay.allow-extension-background-pages", true);

/*** other ***/

/* allow installation of unsigned extensions */
/* just in developer and nightly editions */
// user_pref("xpinstall.signatures.required", false);
// user_pref("extensions.langpacks.signatures.required", false);

/* enable hardware acceleration */
/* may give video problems */
// user_pref("media.ffmpeg.vaapi.enabled", true);

/* dark UI (not really working with resistFingerprinting) */
/* it breaks startpage */
// user_pref("widget.content.allow-gtk-dark-theme", true);
// user_pref("widget.gtk.alt-theme.dark", true);

/* increase to 127 (maximum) the replacements allowed via fontconfig */
// user_pref("gfx.font_rendering.fontconfig.max_generic_substitutions", 127);

/* set dpi to 96 (no scaling) */
// user_pref("layout.css.dpi", 96);

/* enable math css */
// user_pref("layout.css.math-style.enabled", true);
// user_pref("layout.css.math-depth.enabled", true);

user_pref("_user.js.parrot", "extra section success");
