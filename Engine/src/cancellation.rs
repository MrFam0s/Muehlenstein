// SPDX-License-Identifier: AGPL-3.0-or-later
//! Cancellation IDs keep foreign callers away from shared raw pointers.
use std::collections::HashMap;
use std::sync::{
    Arc, Mutex, OnceLock,
    atomic::{AtomicBool, AtomicU64, Ordering},
};

static TOKENS: OnceLock<Mutex<HashMap<u64, Arc<AtomicBool>>>> = OnceLock::new();
static NEXT: AtomicU64 = AtomicU64::new(1);
fn tokens() -> &'static Mutex<HashMap<u64, Arc<AtomicBool>>> {
    TOKENS.get_or_init(|| Mutex::new(HashMap::new()))
}
pub fn flag(id: Option<u64>) -> Result<Arc<AtomicBool>, String> {
    match id {
        None => Ok(Arc::new(AtomicBool::new(false))),
        Some(id) => tokens()
            .lock()
            .map_err(|_| "cancelRegistryUnavailable")?
            .get(&id)
            .cloned()
            .ok_or_else(|| "invalidSearchID".into()),
    }
}
#[unsafe(no_mangle)]
pub extern "C" fn ms_search_create() -> u64 {
    let Ok(mut entries) = tokens().lock() else {
        return 0;
    };
    let id = NEXT.fetch_add(1, Ordering::Relaxed);
    if id == 0 || entries.contains_key(&id) {
        return 0;
    }
    entries.insert(id, Arc::new(AtomicBool::new(false)));
    id
}
#[unsafe(no_mangle)]
pub extern "C" fn ms_search_cancel(id: u64) {
    if let Ok(flag) = flag(Some(id)) {
        flag.store(true, Ordering::Relaxed);
    }
}
#[unsafe(no_mangle)]
pub extern "C" fn ms_search_release(id: u64) {
    // An in-flight search owns an Arc, so removing the registry entry is safe.
    if let Ok(mut entries) = tokens().lock() {
        entries.remove(&id);
    }
}
