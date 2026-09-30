#ifndef MUEHLENSTEIN_ENGINE_H
#define MUEHLENSTEIN_ENGINE_H
#include <stdint.h>
uint64_t ms_search_create(void);
void ms_search_cancel(uint64_t id);
void ms_search_release(uint64_t id);
// A request is a UTF-8 JSON C string. The response is owned by Rust.
// Call ms_string_free exactly once for every non-null response.
char *ms_request(const char *request);
void ms_string_free(char *response);
#endif
