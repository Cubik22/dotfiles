/*** sync ***/

user_pref("_user.js.parrot", "sync section syntax error");

user_pref("identity.fxaccounts.enabled", true); // Firefox Accounts & Sync [FF60+] [RESTART]

user_pref("services.sync.engine.prefs", false);
user_pref("services.sync.engine.prefs.modified", false);
user_pref("services.sync.engine.creditcards", false);
user_pref("services.sync.engine.creditcards.available", false);
user_pref("services.sync.engine.addresses", false);
user_pref("services.sync.engine.addresses.available", false);
user_pref("services.sync.engine.addons", false);
user_pref("services.sync.engine.passwords", false);

user_pref("services.sync.declinedEngines", "prefs,creditcards,passwords,addons");

user_pref("_user.js.parrot", "sync section success");
