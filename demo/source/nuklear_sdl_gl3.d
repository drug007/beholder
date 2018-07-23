

        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        struct __locale_data { int dummy; }

alias _Bool = bool;
struct dpp {
    static struct Move(T) {
        T* ptr;
    }

    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{
    struct __sigset_t
    {
        c_ulong[16] __val;
    }
    alias __FILE = _IO_FILE;


    alias timer_t = void*;


    alias time_t = c_long;
    alias FILE = _IO_FILE;


    alias sigset_t = __sigset_t;
    alias clock_t = c_long;
    alias clockid_t = int;
    struct timespec
    {
        __time_t tv_sec;
        __syscall_slong_t tv_nsec;
    }


    struct timeval
    {
        __time_t tv_sec;
        __suseconds_t tv_usec;
    }
    struct __mbstate_t
    {
        int __count;
        static union _Anonymous_0
        {
            uint __wch;
            char[4] __wchb;
        }
        _Anonymous_0 __value;
    }
    alias uint8_t = ubyte;


    alias int8_t = byte;
    alias uint16_t = ushort;
    alias int16_t = short;






    alias uint32_t = uint;
    extern __gshared int sys_nerr;


    alias int32_t = int;
    struct _G_fpos_t
    {
        __off_t __pos;
        __mbstate_t __state;
    }
    alias pthread_t = c_ulong;
    extern __gshared const(const(char)*)[0] sys_errlist;




    alias uint64_t = c_ulong;
    alias int64_t = c_long;
    alias __u_char = ubyte;




    alias __u_short = ushort;



    struct _G_fpos64_t
    {
        __off64_t __pos;
        __mbstate_t __state;
    }
    static __uint16_t __uint16_identity(__uint16_t) @nogc nothrow;
    alias __u_int = uint;
    void* alloca(size_t) @nogc nothrow;
    union pthread_mutexattr_t
    {
        char[4] __size;
        int __align;
    }






    alias __u_long = c_ulong;
    alias u_char = ubyte;


    alias u_short = ushort;
    alias u_int = uint;







    alias u_long = c_ulong;
    alias __int8_t = byte;






    alias __uint8_t = ubyte;
    alias quad_t = c_long;


    static __uint32_t __uint32_identity(__uint32_t) @nogc nothrow;






    alias u_quad_t = c_ulong;




    alias __int16_t = short;
    alias fsid_t = __fsid_t;
    alias __uint16_t = ushort;







    alias __int32_t = int;
    alias __uint32_t = uint;


    union pthread_condattr_t
    {
        char[4] __size;
        int __align;
    }






    alias int_least8_t = byte;


    alias suseconds_t = c_long;


    alias __int64_t = c_long;






    alias __uint64_t = c_ulong;




    alias loff_t = c_long;


    alias int_least16_t = short;


    static __uint64_t __uint64_identity(__uint64_t) @nogc nothrow;
    alias int_least32_t = int;
    alias int_least64_t = c_long;
    alias ino_t = c_ulong;






    alias __fd_mask = c_long;
    alias pthread_key_t = uint;
    enum idtype_t
    {
        P_ALL = 0,
        P_PID = 1,
        P_PGID = 2,
    }
    enum P_ALL = idtype_t.P_ALL;
    enum P_PID = idtype_t.P_PID;
    enum P_PGID = idtype_t.P_PGID;


    alias __quad_t = c_long;




    alias __u_quad_t = c_ulong;


    alias pthread_once_t = int;
    alias uint_least8_t = ubyte;
    alias uint_least16_t = ushort;
    union pthread_attr_t
    {
        char[56] __size;
        c_long __align;
    }
    alias uint_least32_t = uint;
    alias uint_least64_t = c_ulong;





    struct div_t
    {
        int quot;
        int rem;
    }
    struct fd_set
    {
        __fd_mask[16] __fds_bits;
    }





    alias dev_t = c_ulong;







    alias __intmax_t = c_long;
    alias __uintmax_t = c_ulong;
    alias size_t = c_ulong;
    alias gid_t = uint;






    struct __pthread_rwlock_arch_t
    {
        uint __readers;
        uint __writers;
        uint __wrphase_futex;
        uint __writers_futex;
        uint __pad3;
        uint __pad4;
        int __cur_writer;
        int __shared;
        byte __rwelision;
        ubyte[7] __pad1;
        c_ulong __pad2;
        uint __flags;
    }
    struct ldiv_t
    {
        c_long quot;
        c_long rem;
    }
    union pthread_mutex_t
    {
        __pthread_mutex_s __data;
        char[40] __size;
        c_long __align;
    }




    alias int_fast8_t = byte;
    void __assert_fail(const(char)*, const(char)*, uint, const(char)*) @nogc nothrow;
    alias mode_t = uint;
    alias int_fast16_t = c_long;






    alias int_fast32_t = c_long;
    alias int_fast64_t = c_long;


    uint gnu_dev_major(__dev_t) @nogc nothrow;


    uint gnu_dev_minor(__dev_t) @nogc nothrow;


    void __assert_perror_fail(int, const(char)*, uint, const(char)*) @nogc nothrow;


    union pthread_cond_t
    {
        __pthread_cond_s __data;
        char[48] __size;
        long __align;
    }
    alias nlink_t = c_ulong;


    __dev_t gnu_dev_makedev(uint, uint) @nogc nothrow;
    struct lldiv_t
    {
        long quot;
        long rem;
    }




    alias fd_mask = c_long;


    alias fpos_t = _G_fpos_t;


    alias uid_t = uint;






    void __assert(const(char)*, const(char)*, int) @nogc nothrow;


    alias uint_fast8_t = ubyte;


    struct __pthread_internal_list
    {
        __pthread_internal_list* __prev;
        __pthread_internal_list* __next;
    }
    alias __pthread_list_t = __pthread_internal_list;




    alias uint_fast16_t = c_ulong;




    alias uint_fast32_t = c_ulong;
    alias uint_fast64_t = c_ulong;
    union pthread_rwlock_t
    {
        __pthread_rwlock_arch_t __data;
        char[56] __size;
        c_long __align;
    }
    alias off_t = c_long;
    alias wchar_t = int;






    union pthread_rwlockattr_t
    {
        char[8] __size;
        c_long __align;
    }
    alias intptr_t = c_long;




    size_t __ctype_get_mb_cur_max() @nogc nothrow;
    alias pid_t = int;
    alias uintptr_t = c_ulong;
    int select(int, fd_set*, fd_set*, fd_set*, timeval*) @nogc nothrow;
    double atof(const(char)*) @nogc nothrow;
    alias pthread_spinlock_t = int;






    alias id_t = uint;


    int atoi(const(char)*) @nogc nothrow;
    c_long atol(const(char)*) @nogc nothrow;
    union pthread_barrier_t
    {
        char[32] __size;
        c_long __align;
    }






    alias ssize_t = c_long;






    alias intmax_t = c_long;


    long atoll(const(char)*) @nogc nothrow;
    alias uintmax_t = c_ulong;




    int pselect(int, fd_set*, fd_set*, fd_set*, const(timespec)*, const(__sigset_t)*) @nogc nothrow;




    union pthread_barrierattr_t
    {
        char[4] __size;
        int __align;
    }
    alias daddr_t = int;


    alias caddr_t = char*;
    double strtod(const(char)*, char**) @nogc nothrow;


    struct __pthread_mutex_s
    {
        int __lock;
        uint __count;
        int __owner;
        uint __nusers;
        int __kind;
        short __spins;
        short __elision;
        __pthread_list_t __list;
    }
    alias key_t = int;


    float strtof(const(char)*, char**) @nogc nothrow;






    real strtold(const(char)*, char**) @nogc nothrow;
    alias __dev_t = c_ulong;






    alias __uid_t = uint;


    alias __gid_t = uint;
    extern __gshared _IO_FILE* stdin;


    alias __ino_t = c_ulong;
    extern __gshared _IO_FILE* stdout;




    extern __gshared _IO_FILE* stderr;
    alias __ino64_t = c_ulong;




    alias __mode_t = uint;
    alias __nlink_t = c_ulong;
    alias __off_t = c_long;




    alias __off64_t = c_long;
    alias __pid_t = int;
    struct __fsid_t
    {
        int[2] __val;
    }
    int remove(const(char)*) @nogc nothrow;




    alias __clock_t = c_long;
    alias __rlim_t = c_ulong;




    alias __rlim64_t = c_ulong;




    int rename(const(char)*, const(char)*) @nogc nothrow;
    alias __id_t = uint;




    alias __time_t = c_long;


    struct _IO_jump_t;
    alias __useconds_t = uint;
    int renameat(int, const(char)*, int, const(char)*) @nogc nothrow;


    alias __suseconds_t = c_long;
    struct __pthread_cond_s
    {
        static union _Anonymous_1
        {
            ulong __wseq;
            static struct _Anonymous_2
            {
                uint __low;
                uint __high;
            }
            _Anonymous_2 __wseq32;
        }
        _Anonymous_1 _anonymous_3;
        auto __wseq() @property @nogc pure nothrow { return _anonymous_3.__wseq; }
        void __wseq(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_3.__wseq = val; }
        auto __wseq32() @property @nogc pure nothrow { return _anonymous_3.__wseq32; }
        void __wseq32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_3.__wseq32 = val; }
        static union _Anonymous_4
        {
            ulong __g1_start;
            static struct _Anonymous_5
            {
                uint __low;
                uint __high;
            }
            _Anonymous_5 __g1_start32;
        }
        _Anonymous_4 _anonymous_6;
        auto __g1_start() @property @nogc pure nothrow { return _anonymous_6.__g1_start; }
        void __g1_start(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_6.__g1_start = val; }
        auto __g1_start32() @property @nogc pure nothrow { return _anonymous_6.__g1_start32; }
        void __g1_start32(_T_)(auto ref _T_ val) @property @nogc pure nothrow { _anonymous_6.__g1_start32 = val; }
        uint[2] __g_refs;
        uint[2] __g_size;
        uint __g1_orig_size;
        uint __wrefs;
        uint[2] __g_signals;
    }




    alias __daddr_t = int;
    alias __key_t = int;


    alias _IO_lock_t = void;




    alias __clockid_t = int;







    alias __timer_t = void*;
    FILE* tmpfile() @nogc nothrow;
    struct _IO_marker
    {
        _IO_marker* _next;
        _IO_FILE* _sbuf;
        int _pos;
    }


    alias __blksize_t = c_long;






    alias __blkcnt_t = c_long;
    alias __blkcnt64_t = c_long;
    alias __fsblkcnt_t = c_ulong;


    alias __fsblkcnt64_t = c_ulong;
    char* tmpnam(char*) @nogc nothrow;







    alias __fsfilcnt_t = c_ulong;
    alias __fsfilcnt64_t = c_ulong;





    c_long strtol(const(char)*, char**, int) @nogc nothrow;
    char* tmpnam_r(char*) @nogc nothrow;
    alias u_int8_t = ubyte;



    alias u_int16_t = ushort;
    alias __fsword_t = c_long;
    enum __codecvt_result
    {
        __codecvt_ok = 0,
        __codecvt_partial = 1,
        __codecvt_error = 2,
        __codecvt_noconv = 3,
    }
    enum __codecvt_ok = __codecvt_result.__codecvt_ok;
    enum __codecvt_partial = __codecvt_result.__codecvt_partial;
    enum __codecvt_error = __codecvt_result.__codecvt_error;
    enum __codecvt_noconv = __codecvt_result.__codecvt_noconv;
    alias u_int32_t = uint;
    c_ulong strtoul(const(char)*, char**, int) @nogc nothrow;


    alias __ssize_t = c_long;


    alias u_int64_t = c_ulong;


    alias register_t = c_long;


    alias __syscall_slong_t = c_long;




    alias __syscall_ulong_t = c_ulong;
    long strtoq(const(char)*, char**, int) @nogc nothrow;


    alias __loff_t = c_long;
    char* tempnam(const(char)*, const(char)*) @nogc nothrow;
    alias __caddr_t = char*;


    ulong strtouq(const(char)*, char**, int) @nogc nothrow;
    alias __intptr_t = c_long;


    alias __socklen_t = uint;




    int fclose(FILE*) @nogc nothrow;
    long strtoll(const(char)*, char**, int) @nogc nothrow;
    alias __sig_atomic_t = int;




    int fflush(FILE*) @nogc nothrow;
    ulong strtoull(const(char)*, char**, int) @nogc nothrow;


    alias _Float32 = float;






    alias blksize_t = c_long;




    int fflush_unlocked(FILE*) @nogc nothrow;
    alias blkcnt_t = c_long;
    alias fsblkcnt_t = c_ulong;




    alias fsfilcnt_t = c_ulong;
    FILE* fopen(const(char)*, const(char)*) @nogc nothrow;
    FILE* freopen(const(char)*, const(char)*, FILE*) @nogc nothrow;






    alias _Float64 = double;
    struct _IO_FILE
    {
        int _flags;
        char* _IO_read_ptr;
        char* _IO_read_end;
        char* _IO_read_base;
        char* _IO_write_base;
        char* _IO_write_ptr;
        char* _IO_write_end;
        char* _IO_buf_base;
        char* _IO_buf_end;
        char* _IO_save_base;
        char* _IO_backup_base;
        char* _IO_save_end;
        _IO_marker* _markers;
        _IO_FILE* _chain;
        int _fileno;
        int _flags2;
        __off_t _old_offset;
        ushort _cur_column;
        byte _vtable_offset;
        char[1] _shortbuf;
        _IO_lock_t* _lock;
        __off64_t _offset;
        void* __pad1;
        void* __pad2;
        void* __pad3;
        void* __pad4;
        size_t __pad5;
        int _mode;
        char[20] _unused2;
    }
    alias _Float32x = double;






    FILE* fdopen(int, const(char)*) @nogc nothrow;
    FILE* fmemopen(void*, size_t, const(char)*) @nogc nothrow;
    alias _Float64x = real;
    FILE* open_memstream(char**, size_t*) @nogc nothrow;
    void setbuf(FILE*, char*) @nogc nothrow;
    int setvbuf(FILE*, char*, int, size_t) @nogc nothrow;







    void setbuffer(FILE*, char*, size_t) @nogc nothrow;
    void setlinebuf(FILE*) @nogc nothrow;
    int fprintf(FILE*, const(char)*, ...) @nogc nothrow;
    struct _IO_FILE_plus;
    int printf(const(char)*, ...) @nogc nothrow;
    int sprintf(char*, const(char)*, ...) @nogc nothrow;
    int vfprintf(FILE*, const(char)*, va_list) @nogc nothrow;
    int vprintf(const(char)*, va_list) @nogc nothrow;


    int vsprintf(char*, const(char)*, va_list) @nogc nothrow;


    alias __io_read_fn = c_long function(void*, char*, size_t);
    int snprintf(char*, size_t, const(char)*, ...) @nogc nothrow;





    int vsnprintf(char*, size_t, const(char)*, va_list) @nogc nothrow;
    alias __io_write_fn = c_long function(void*, const(char)*, size_t);


    alias __io_seek_fn = int function(void*, __off64_t*, int);
    alias __io_close_fn = int function(void*);
    int vdprintf(int, const(char)*, va_list) @nogc nothrow;
    int dprintf(int, const(char)*, ...) @nogc nothrow;






    int scanf(const(char)*, ...) @nogc nothrow;
    char* l64a(c_long) @nogc nothrow;


    c_long a64l(const(char)*) @nogc nothrow;
    int __underflow(_IO_FILE*) @nogc nothrow;
    int __uflow(_IO_FILE*) @nogc nothrow;
    int __overflow(_IO_FILE*, int) @nogc nothrow;




    int fscanf(FILE*, const(char)*, ...) @nogc nothrow;
    alias nk_char = byte;


    alias nk_uchar = ubyte;
    alias nk_byte = ubyte;
    alias nk_short = short;
    alias nk_ushort = ushort;


    alias nk_int = int;
    int sscanf(const(char)*, const(char)*, ...) @nogc nothrow;
    alias nk_uint = uint;
    c_long random() @nogc nothrow;
    alias nk_size = c_ulong;
    alias nk_ptr = c_ulong;




    void srandom(uint) @nogc nothrow;
    alias nk_hash = uint;
    alias nk_flags = uint;





    alias nk_rune = uint;
    char* initstate(uint, char*, size_t) @nogc nothrow;







    alias _dummy_array412 = char[1];
    alias _dummy_array413 = char[1];
    alias _dummy_array414 = char[1];


    alias _dummy_array415 = char[1];
    char* setstate(char*) @nogc nothrow;


    alias _dummy_array416 = char[1];


    alias _dummy_array417 = char[1];



    alias _dummy_array418 = char[1];
    alias _dummy_array419 = char[1];
    alias _dummy_array420 = char[1];
    struct random_data
    {
        int32_t* fptr;
        int32_t* rptr;
        int32_t* state;
        int rand_type;
        int rand_deg;
        int rand_sep;
        int32_t* end_ptr;
    }




    int vsscanf(const(char)*, const(char)*, va_list) @nogc nothrow;
    int _IO_getc(_IO_FILE*) @nogc nothrow;
    int _IO_putc(int, _IO_FILE*) @nogc nothrow;
    int random_r(random_data*, int32_t*) @nogc nothrow;
    int _IO_feof(_IO_FILE*) @nogc nothrow;
    int _IO_ferror(_IO_FILE*) @nogc nothrow;
    int srandom_r(uint, random_data*) @nogc nothrow;
    int _IO_peekc_locked(_IO_FILE*) @nogc nothrow;
    int initstate_r(uint, char*, size_t, random_data*) @nogc nothrow;



    struct nk_style_slide;
    int vfscanf(FILE*, const(char)*, va_list) @nogc nothrow;
    void _IO_flockfile(_IO_FILE*) @nogc nothrow;
    void _IO_funlockfile(_IO_FILE*) @nogc nothrow;
    int setstate_r(char*, random_data*) @nogc nothrow;
    int _IO_ftrylockfile(_IO_FILE*) @nogc nothrow;
    int vscanf(const(char)*, va_list) @nogc nothrow;
    int rand() @nogc nothrow;




    struct nk_color
    {
        nk_byte r;
        nk_byte g;
        nk_byte b;
        nk_byte a;
    }


    void srand(uint) @nogc nothrow;
    struct nk_colorf
    {
        float r;
        float g;
        float b;
        float a;
    }
    struct nk_vec2
    {
        float x;
        float y;
    }




    struct nk_vec2i
    {
        short x;
        short y;
    }



    struct nk_rect
    {
        float x;
        float y;
        float w;
        float h;
    }
    struct nk_recti
    {
        short x;
        short y;
        short w;
        short h;
    }



    int rand_r(uint*) @nogc nothrow;
    alias nk_glyph = char[4];
    union nk_handle
    {
        void* ptr;
        int id;
    }
    int _IO_vfscanf(_IO_FILE*, const(char)*, va_list, int*) @nogc nothrow;
    struct nk_image
    {
        nk_handle handle;
        ushort w;
        ushort h;
        ushort[4] region;
    }
    struct nk_cursor
    {
        nk_image img;
        nk_vec2 size;
        nk_vec2 offset;
    }
    int _IO_vfprintf(_IO_FILE*, const(char)*, va_list) @nogc nothrow;
    struct nk_scroll
    {
        nk_uint x;
        nk_uint y;
    }
    enum nk_heading
    {
        NK_UP = 0,
        NK_RIGHT = 1,
        NK_DOWN = 2,
        NK_LEFT = 3,
    }
    enum NK_UP = nk_heading.NK_UP;
    enum NK_RIGHT = nk_heading.NK_RIGHT;
    enum NK_DOWN = nk_heading.NK_DOWN;
    enum NK_LEFT = nk_heading.NK_LEFT;
    __ssize_t _IO_padn(_IO_FILE*, int, __ssize_t) @nogc nothrow;
    size_t _IO_sgetn(_IO_FILE*, void*, size_t) @nogc nothrow;
    double drand48() @nogc nothrow;
    enum nk_button_behavior
    {
        NK_BUTTON_DEFAULT = 0,
        NK_BUTTON_REPEATER = 1,
    }
    enum NK_BUTTON_DEFAULT = nk_button_behavior.NK_BUTTON_DEFAULT;
    enum NK_BUTTON_REPEATER = nk_button_behavior.NK_BUTTON_REPEATER;
    double erand48(ushort*) @nogc nothrow;


    enum nk_modify
    {
        NK_FIXED = 0,
        NK_MODIFIABLE = 1,
    }
    enum NK_FIXED = nk_modify.NK_FIXED;
    enum NK_MODIFIABLE = nk_modify.NK_MODIFIABLE;



    __off64_t _IO_seekoff(_IO_FILE*, __off64_t, int, int) @nogc nothrow;
    enum nk_orientation
    {
        NK_VERTICAL = 0,
        NK_HORIZONTAL = 1,
    }
    enum NK_VERTICAL = nk_orientation.NK_VERTICAL;
    enum NK_HORIZONTAL = nk_orientation.NK_HORIZONTAL;
    __off64_t _IO_seekpos(_IO_FILE*, __off64_t, int) @nogc nothrow;
    enum nk_collapse_states
    {
        NK_MINIMIZED = 0,
        NK_MAXIMIZED = 1,
    }
    enum NK_MINIMIZED = nk_collapse_states.NK_MINIMIZED;
    enum NK_MAXIMIZED = nk_collapse_states.NK_MAXIMIZED;
    enum nk_show_states
    {
        NK_HIDDEN = 0,
        NK_SHOWN = 1,
    }
    enum NK_HIDDEN = nk_show_states.NK_HIDDEN;
    enum NK_SHOWN = nk_show_states.NK_SHOWN;
    c_long lrand48() @nogc nothrow;
    enum nk_chart_type
    {
        NK_CHART_LINES = 0,
        NK_CHART_COLUMN = 1,
        NK_CHART_MAX = 2,
    }
    enum NK_CHART_LINES = nk_chart_type.NK_CHART_LINES;
    enum NK_CHART_COLUMN = nk_chart_type.NK_CHART_COLUMN;
    enum NK_CHART_MAX = nk_chart_type.NK_CHART_MAX;
    void _IO_free_backup_area(_IO_FILE*) @nogc nothrow;
    c_long nrand48(ushort*) @nogc nothrow;
    enum nk_chart_event
    {
        NK_CHART_HOVERING = 1,
        NK_CHART_CLICKED = 2,
    }
    enum NK_CHART_HOVERING = nk_chart_event.NK_CHART_HOVERING;
    enum NK_CHART_CLICKED = nk_chart_event.NK_CHART_CLICKED;
    enum nk_color_format
    {
        NK_RGB = 0,
        NK_RGBA = 1,
    }
    enum NK_RGB = nk_color_format.NK_RGB;
    enum NK_RGBA = nk_color_format.NK_RGBA;
    enum nk_popup_type
    {
        NK_POPUP_STATIC = 0,
        NK_POPUP_DYNAMIC = 1,
    }
    enum NK_POPUP_STATIC = nk_popup_type.NK_POPUP_STATIC;
    enum NK_POPUP_DYNAMIC = nk_popup_type.NK_POPUP_DYNAMIC;
    enum nk_layout_format
    {
        NK_DYNAMIC = 0,
        NK_STATIC = 1,
    }
    enum NK_DYNAMIC = nk_layout_format.NK_DYNAMIC;
    enum NK_STATIC = nk_layout_format.NK_STATIC;
    c_long mrand48() @nogc nothrow;
    int fgetc(FILE*) @nogc nothrow;
    enum nk_tree_type
    {
        NK_TREE_NODE = 0,
        NK_TREE_TAB = 1,
    }
    enum NK_TREE_NODE = nk_tree_type.NK_TREE_NODE;
    enum NK_TREE_TAB = nk_tree_type.NK_TREE_TAB;
    c_long jrand48(ushort*) @nogc nothrow;
    int getc(FILE*) @nogc nothrow;
    alias nk_plugin_alloc = void* function(nk_handle, void*, nk_size);
    alias nk_plugin_free = void function(nk_handle, void*);
    alias nk_plugin_filter = int function(const(nk_text_edit)*, nk_rune);
    void srand48(c_long) @nogc nothrow;
    alias nk_plugin_paste = void function(nk_handle, nk_text_edit*);
    ushort* seed48(ushort*) @nogc nothrow;
    alias nk_plugin_copy = void function(nk_handle, const(char)*, int);
    void lcong48(ushort*) @nogc nothrow;
    int getchar() @nogc nothrow;
    struct nk_allocator
    {
        nk_handle userdata;
        nk_plugin_alloc alloc;
        nk_plugin_free free;
    }




    enum nk_symbol_type
    {
        NK_SYMBOL_NONE = 0,
        NK_SYMBOL_X = 1,
        NK_SYMBOL_UNDERSCORE = 2,
        NK_SYMBOL_CIRCLE_SOLID = 3,
        NK_SYMBOL_CIRCLE_OUTLINE = 4,
        NK_SYMBOL_RECT_SOLID = 5,
        NK_SYMBOL_RECT_OUTLINE = 6,
        NK_SYMBOL_TRIANGLE_UP = 7,
        NK_SYMBOL_TRIANGLE_DOWN = 8,
        NK_SYMBOL_TRIANGLE_LEFT = 9,
        NK_SYMBOL_TRIANGLE_RIGHT = 10,
        NK_SYMBOL_PLUS = 11,
        NK_SYMBOL_MINUS = 12,
        NK_SYMBOL_MAX = 13,
    }
    enum NK_SYMBOL_NONE = nk_symbol_type.NK_SYMBOL_NONE;
    enum NK_SYMBOL_X = nk_symbol_type.NK_SYMBOL_X;
    enum NK_SYMBOL_UNDERSCORE = nk_symbol_type.NK_SYMBOL_UNDERSCORE;
    enum NK_SYMBOL_CIRCLE_SOLID = nk_symbol_type.NK_SYMBOL_CIRCLE_SOLID;
    enum NK_SYMBOL_CIRCLE_OUTLINE = nk_symbol_type.NK_SYMBOL_CIRCLE_OUTLINE;
    enum NK_SYMBOL_RECT_SOLID = nk_symbol_type.NK_SYMBOL_RECT_SOLID;
    enum NK_SYMBOL_RECT_OUTLINE = nk_symbol_type.NK_SYMBOL_RECT_OUTLINE;
    enum NK_SYMBOL_TRIANGLE_UP = nk_symbol_type.NK_SYMBOL_TRIANGLE_UP;
    enum NK_SYMBOL_TRIANGLE_DOWN = nk_symbol_type.NK_SYMBOL_TRIANGLE_DOWN;
    enum NK_SYMBOL_TRIANGLE_LEFT = nk_symbol_type.NK_SYMBOL_TRIANGLE_LEFT;
    enum NK_SYMBOL_TRIANGLE_RIGHT = nk_symbol_type.NK_SYMBOL_TRIANGLE_RIGHT;
    enum NK_SYMBOL_PLUS = nk_symbol_type.NK_SYMBOL_PLUS;
    enum NK_SYMBOL_MINUS = nk_symbol_type.NK_SYMBOL_MINUS;
    enum NK_SYMBOL_MAX = nk_symbol_type.NK_SYMBOL_MAX;
    struct drand48_data
    {
        ushort[3] __x;
        ushort[3] __old_x;
        ushort __c;
        ushort __init;
        ulong __a;
    }
    int getc_unlocked(FILE*) @nogc nothrow;
    int getchar_unlocked() @nogc nothrow;
    int drand48_r(drand48_data*, double*) @nogc nothrow;
    int erand48_r(ushort*, drand48_data*, double*) @nogc nothrow;
    int fgetc_unlocked(FILE*) @nogc nothrow;
    int lrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int nrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    int mrand48_r(drand48_data*, c_long*) @nogc nothrow;
    int fputc(int, FILE*) @nogc nothrow;
    int putc(int, FILE*) @nogc nothrow;
    int jrand48_r(ushort*, drand48_data*, c_long*) @nogc nothrow;
    int putchar(int) @nogc nothrow;
    int srand48_r(c_long, drand48_data*) @nogc nothrow;


    int seed48_r(ushort*, drand48_data*) @nogc nothrow;
    int lcong48_r(ushort*, drand48_data*) @nogc nothrow;
    int fputc_unlocked(int, FILE*) @nogc nothrow;
    void* malloc(size_t) @nogc nothrow;
    void* calloc(size_t, size_t) @nogc nothrow;
    int putc_unlocked(int, FILE*) @nogc nothrow;
    int putchar_unlocked(int) @nogc nothrow;
    void* realloc(void*, size_t) @nogc nothrow;
    int getw(FILE*) @nogc nothrow;
    int putw(int, FILE*) @nogc nothrow;
    int nk_init_default(nk_context*, const(nk_user_font)*) @nogc nothrow;
    void free(void*) @nogc nothrow;
    char* fgets(char*, int, FILE*) @nogc nothrow;
    void* valloc(size_t) @nogc nothrow;
    int posix_memalign(void**, size_t, size_t) @nogc nothrow;
    void* aligned_alloc(size_t, size_t) @nogc nothrow;
    void abort() @nogc nothrow;
    int atexit(void function()) @nogc nothrow;
    int at_quick_exit(void function()) @nogc nothrow;
    __ssize_t __getdelim(char**, size_t*, int, FILE*) @nogc nothrow;
    int nk_init(nk_context*, nk_allocator*, const(nk_user_font)*) @nogc nothrow;
    __ssize_t getdelim(char**, size_t*, int, FILE*) @nogc nothrow;
    int on_exit(void function(int, void*), void*) @nogc nothrow;
    void exit(int) @nogc nothrow;
    __ssize_t getline(char**, size_t*, FILE*) @nogc nothrow;
    void quick_exit(int) @nogc nothrow;
    int nk_init_custom(nk_context*, nk_buffer*, nk_buffer*, const(nk_user_font)*) @nogc nothrow;
    void _Exit(int) @nogc nothrow;
    int fputs(const(char)*, FILE*) @nogc nothrow;
    char* getenv(const(char)*) @nogc nothrow;
    int puts(const(char)*) @nogc nothrow;
    void nk_clear(nk_context*) @nogc nothrow;
    int ungetc(int, FILE*) @nogc nothrow;
    int putenv(char*) @nogc nothrow;
    size_t fread(void*, size_t, size_t, FILE*) @nogc nothrow;
    void nk_free(nk_context*) @nogc nothrow;
    int setenv(const(char)*, const(char)*, int) @nogc nothrow;
    size_t fwrite(const(void)*, size_t, size_t, FILE*) @nogc nothrow;
    int unsetenv(const(char)*) @nogc nothrow;
    int clearenv() @nogc nothrow;
    char* mktemp(char*) @nogc nothrow;
    size_t fread_unlocked(void*, size_t, size_t, FILE*) @nogc nothrow;
    size_t fwrite_unlocked(const(void)*, size_t, size_t, FILE*) @nogc nothrow;
    int fseek(FILE*, c_long, int) @nogc nothrow;
    int mkstemp(char*) @nogc nothrow;
    c_long ftell(FILE*) @nogc nothrow;
    void rewind(FILE*) @nogc nothrow;
    int fseeko(FILE*, __off_t, int) @nogc nothrow;
    int mkstemps(char*, int) @nogc nothrow;
    __off_t ftello(FILE*) @nogc nothrow;
    char* mkdtemp(char*) @nogc nothrow;
    int fgetpos(FILE*, fpos_t*) @nogc nothrow;
    enum nk_keys
    {
        NK_KEY_NONE = 0,
        NK_KEY_SHIFT = 1,
        NK_KEY_CTRL = 2,
        NK_KEY_DEL = 3,
        NK_KEY_ENTER = 4,
        NK_KEY_TAB = 5,
        NK_KEY_BACKSPACE = 6,
        NK_KEY_COPY = 7,
        NK_KEY_CUT = 8,
        NK_KEY_PASTE = 9,
        NK_KEY_UP = 10,
        NK_KEY_DOWN = 11,
        NK_KEY_LEFT = 12,
        NK_KEY_RIGHT = 13,
        NK_KEY_TEXT_INSERT_MODE = 14,
        NK_KEY_TEXT_REPLACE_MODE = 15,
        NK_KEY_TEXT_RESET_MODE = 16,
        NK_KEY_TEXT_LINE_START = 17,
        NK_KEY_TEXT_LINE_END = 18,
        NK_KEY_TEXT_START = 19,
        NK_KEY_TEXT_END = 20,
        NK_KEY_TEXT_UNDO = 21,
        NK_KEY_TEXT_REDO = 22,
        NK_KEY_TEXT_SELECT_ALL = 23,
        NK_KEY_TEXT_WORD_LEFT = 24,
        NK_KEY_TEXT_WORD_RIGHT = 25,
        NK_KEY_SCROLL_START = 26,
        NK_KEY_SCROLL_END = 27,
        NK_KEY_SCROLL_DOWN = 28,
        NK_KEY_SCROLL_UP = 29,
        NK_KEY_MAX = 30,
    }
    enum NK_KEY_NONE = nk_keys.NK_KEY_NONE;
    enum NK_KEY_SHIFT = nk_keys.NK_KEY_SHIFT;
    enum NK_KEY_CTRL = nk_keys.NK_KEY_CTRL;
    enum NK_KEY_DEL = nk_keys.NK_KEY_DEL;
    enum NK_KEY_ENTER = nk_keys.NK_KEY_ENTER;
    enum NK_KEY_TAB = nk_keys.NK_KEY_TAB;
    enum NK_KEY_BACKSPACE = nk_keys.NK_KEY_BACKSPACE;
    enum NK_KEY_COPY = nk_keys.NK_KEY_COPY;
    enum NK_KEY_CUT = nk_keys.NK_KEY_CUT;
    enum NK_KEY_PASTE = nk_keys.NK_KEY_PASTE;
    enum NK_KEY_UP = nk_keys.NK_KEY_UP;
    enum NK_KEY_DOWN = nk_keys.NK_KEY_DOWN;
    enum NK_KEY_LEFT = nk_keys.NK_KEY_LEFT;
    enum NK_KEY_RIGHT = nk_keys.NK_KEY_RIGHT;
    enum NK_KEY_TEXT_INSERT_MODE = nk_keys.NK_KEY_TEXT_INSERT_MODE;
    enum NK_KEY_TEXT_REPLACE_MODE = nk_keys.NK_KEY_TEXT_REPLACE_MODE;
    enum NK_KEY_TEXT_RESET_MODE = nk_keys.NK_KEY_TEXT_RESET_MODE;
    enum NK_KEY_TEXT_LINE_START = nk_keys.NK_KEY_TEXT_LINE_START;
    enum NK_KEY_TEXT_LINE_END = nk_keys.NK_KEY_TEXT_LINE_END;
    enum NK_KEY_TEXT_START = nk_keys.NK_KEY_TEXT_START;
    enum NK_KEY_TEXT_END = nk_keys.NK_KEY_TEXT_END;
    enum NK_KEY_TEXT_UNDO = nk_keys.NK_KEY_TEXT_UNDO;
    enum NK_KEY_TEXT_REDO = nk_keys.NK_KEY_TEXT_REDO;
    enum NK_KEY_TEXT_SELECT_ALL = nk_keys.NK_KEY_TEXT_SELECT_ALL;
    enum NK_KEY_TEXT_WORD_LEFT = nk_keys.NK_KEY_TEXT_WORD_LEFT;
    enum NK_KEY_TEXT_WORD_RIGHT = nk_keys.NK_KEY_TEXT_WORD_RIGHT;
    enum NK_KEY_SCROLL_START = nk_keys.NK_KEY_SCROLL_START;
    enum NK_KEY_SCROLL_END = nk_keys.NK_KEY_SCROLL_END;
    enum NK_KEY_SCROLL_DOWN = nk_keys.NK_KEY_SCROLL_DOWN;
    enum NK_KEY_SCROLL_UP = nk_keys.NK_KEY_SCROLL_UP;
    enum NK_KEY_MAX = nk_keys.NK_KEY_MAX;
    int fsetpos(FILE*, const(fpos_t)*) @nogc nothrow;
    void clearerr(FILE*) @nogc nothrow;
    int feof(FILE*) @nogc nothrow;
    int ferror(FILE*) @nogc nothrow;
    void clearerr_unlocked(FILE*) @nogc nothrow;
    int feof_unlocked(FILE*) @nogc nothrow;
    enum nk_buttons
    {
        NK_BUTTON_LEFT = 0,
        NK_BUTTON_MIDDLE = 1,
        NK_BUTTON_RIGHT = 2,
        NK_BUTTON_DOUBLE = 3,
        NK_BUTTON_MAX = 4,
    }
    enum NK_BUTTON_LEFT = nk_buttons.NK_BUTTON_LEFT;
    enum NK_BUTTON_MIDDLE = nk_buttons.NK_BUTTON_MIDDLE;
    enum NK_BUTTON_RIGHT = nk_buttons.NK_BUTTON_RIGHT;
    enum NK_BUTTON_DOUBLE = nk_buttons.NK_BUTTON_DOUBLE;
    enum NK_BUTTON_MAX = nk_buttons.NK_BUTTON_MAX;
    int ferror_unlocked(FILE*) @nogc nothrow;
    void perror(const(char)*) @nogc nothrow;
    int system(const(char)*) @nogc nothrow;
    int fileno(FILE*) @nogc nothrow;
    int fileno_unlocked(FILE*) @nogc nothrow;
    char* realpath(const(char)*, char*) @nogc nothrow;
    FILE* popen(const(char)*, const(char)*) @nogc nothrow;


    alias __compar_fn_t = int function(const(void)*, const(void)*);
    int pclose(FILE*) @nogc nothrow;
    char* ctermid(char*) @nogc nothrow;
    void* bsearch(const(void)*, const(void)*, size_t, size_t, __compar_fn_t) @nogc nothrow;
    void qsort(void*, size_t, size_t, __compar_fn_t) @nogc nothrow;
    void nk_input_button(nk_context*, nk_buttons, int, int, int) @nogc nothrow;
    int abs(int) @nogc nothrow;
    c_long labs(c_long) @nogc nothrow;
    void flockfile(FILE*) @nogc nothrow;
    long llabs(long) @nogc nothrow;
    int ftrylockfile(FILE*) @nogc nothrow;
    void funlockfile(FILE*) @nogc nothrow;
    div_t div(int, int) @nogc nothrow;
    ldiv_t ldiv(c_long, c_long) @nogc nothrow;
    lldiv_t lldiv(long, long) @nogc nothrow;
    char* ecvt(double, int, int*, int*) @nogc nothrow;
    char* fcvt(double, int, int*, int*) @nogc nothrow;
    char* gcvt(double, int, char*) @nogc nothrow;
    char* qecvt(real, int, int*, int*) @nogc nothrow;
    char* qfcvt(real, int, int*, int*) @nogc nothrow;
    char* qgcvt(real, int, char*) @nogc nothrow;
    int ecvt_r(double, int, int*, int*, char*, size_t) @nogc nothrow;
    int fcvt_r(double, int, int*, int*, char*, size_t) @nogc nothrow;
    int qecvt_r(real, int, int*, int*, char*, size_t) @nogc nothrow;
    int qfcvt_r(real, int, int*, int*, char*, size_t) @nogc nothrow;
    int mblen(const(char)*, size_t) @nogc nothrow;
    int mbtowc(wchar_t*, const(char)*, size_t) @nogc nothrow;
    int wctomb(char*, wchar_t) @nogc nothrow;
    size_t mbstowcs(wchar_t*, const(char)*, size_t) @nogc nothrow;
    size_t wcstombs(char*, const(wchar_t)*, size_t) @nogc nothrow;
    int rpmatch(const(char)*) @nogc nothrow;
    int getsubopt(char**, char**, char**) @nogc nothrow;
    int getloadavg(double*, int) @nogc nothrow;
    enum nk_anti_aliasing
    {
        NK_ANTI_ALIASING_OFF = 0,
        NK_ANTI_ALIASING_ON = 1,
    }
    enum NK_ANTI_ALIASING_OFF = nk_anti_aliasing.NK_ANTI_ALIASING_OFF;
    enum NK_ANTI_ALIASING_ON = nk_anti_aliasing.NK_ANTI_ALIASING_ON;
    enum nk_convert_result
    {
        NK_CONVERT_SUCCESS = 0,
        NK_CONVERT_INVALID_PARAM = 1,
        NK_CONVERT_COMMAND_BUFFER_FULL = 2,
        NK_CONVERT_VERTEX_BUFFER_FULL = 4,
        NK_CONVERT_ELEMENT_BUFFER_FULL = 8,
    }
    enum NK_CONVERT_SUCCESS = nk_convert_result.NK_CONVERT_SUCCESS;
    enum NK_CONVERT_INVALID_PARAM = nk_convert_result.NK_CONVERT_INVALID_PARAM;
    enum NK_CONVERT_COMMAND_BUFFER_FULL = nk_convert_result.NK_CONVERT_COMMAND_BUFFER_FULL;
    enum NK_CONVERT_VERTEX_BUFFER_FULL = nk_convert_result.NK_CONVERT_VERTEX_BUFFER_FULL;
    enum NK_CONVERT_ELEMENT_BUFFER_FULL = nk_convert_result.NK_CONVERT_ELEMENT_BUFFER_FULL;
    struct nk_draw_null_texture
    {
        nk_handle texture;
        nk_vec2 uv;
    }
    struct nk_convert_config
    {
        float global_alpha;
        nk_anti_aliasing line_AA;
        nk_anti_aliasing shape_AA;
        uint circle_segment_count;
        uint arc_segment_count;
        uint curve_segment_count;
        nk_draw_null_texture null_;
        const(nk_draw_vertex_layout_element)* vertex_layout;
        nk_size vertex_size;
        nk_size vertex_alignment;
    }
    const(nk_command)* nk__begin(nk_context*) @nogc nothrow;
    const(nk_command)* nk__next(nk_context*, const(nk_command)*) @nogc nothrow;




    enum nk_panel_flags
    {
        NK_WINDOW_BORDER = 1,
        NK_WINDOW_MOVABLE = 2,
        NK_WINDOW_SCALABLE = 4,
        NK_WINDOW_CLOSABLE = 8,
        NK_WINDOW_MINIMIZABLE = 16,
        NK_WINDOW_NO_SCROLLBAR = 32,
        NK_WINDOW_TITLE = 64,
        NK_WINDOW_SCROLL_AUTO_HIDE = 128,
        NK_WINDOW_BACKGROUND = 256,
        NK_WINDOW_SCALE_LEFT = 512,
        NK_WINDOW_NO_INPUT = 1024,
    }
    enum NK_WINDOW_BORDER = nk_panel_flags.NK_WINDOW_BORDER;
    enum NK_WINDOW_MOVABLE = nk_panel_flags.NK_WINDOW_MOVABLE;
    enum NK_WINDOW_SCALABLE = nk_panel_flags.NK_WINDOW_SCALABLE;
    enum NK_WINDOW_CLOSABLE = nk_panel_flags.NK_WINDOW_CLOSABLE;
    enum NK_WINDOW_MINIMIZABLE = nk_panel_flags.NK_WINDOW_MINIMIZABLE;
    enum NK_WINDOW_NO_SCROLLBAR = nk_panel_flags.NK_WINDOW_NO_SCROLLBAR;
    enum NK_WINDOW_TITLE = nk_panel_flags.NK_WINDOW_TITLE;
    enum NK_WINDOW_SCROLL_AUTO_HIDE = nk_panel_flags.NK_WINDOW_SCROLL_AUTO_HIDE;
    enum NK_WINDOW_BACKGROUND = nk_panel_flags.NK_WINDOW_BACKGROUND;
    enum NK_WINDOW_SCALE_LEFT = nk_panel_flags.NK_WINDOW_SCALE_LEFT;
    enum NK_WINDOW_NO_INPUT = nk_panel_flags.NK_WINDOW_NO_INPUT;
    int nk_begin(nk_context*, const(char)*, nk_rect, nk_flags) @nogc nothrow;
    nk_rect nk_window_get_bounds(const(nk_context)*) @nogc nothrow;
    nk_vec2 nk_window_get_size(const(nk_context)*) @nogc nothrow;
    float nk_window_get_height(const(nk_context)*) @nogc nothrow;
    int nk_window_has_focus(const(nk_context)*) @nogc nothrow;
    int nk_window_is_any_hovered(nk_context*) @nogc nothrow;
    int nk_item_is_any_active(nk_context*) @nogc nothrow;
    void nk_window_set_size(nk_context*, const(char)*, nk_vec2) @nogc nothrow;
    void nk_layout_reset_min_row_height(nk_context*) @nogc nothrow;
    void nk_layout_row_begin(nk_context*, nk_layout_format, float, int) @nogc nothrow;
    void nk_layout_row_push(nk_context*, float) @nogc nothrow;
    void nk_layout_row_end(nk_context*) @nogc nothrow;
    void nk_layout_row(nk_context*, nk_layout_format, float, int, const(float)*) @nogc nothrow;
    void nk_layout_row_template_push_dynamic(nk_context*) @nogc nothrow;
    void nk_layout_row_template_push_static(nk_context*, float) @nogc nothrow;
    void nk_layout_row_template_end(nk_context*) @nogc nothrow;
    nk_rect nk_layout_space_bounds(nk_context*) @nogc nothrow;
    nk_rect nk_layout_space_rect_to_local(nk_context*, nk_rect) @nogc nothrow;
    int nk_tree_state_image_push(nk_context*, nk_tree_type, nk_image, const(char)*, nk_collapse_states*) @nogc nothrow;




    struct nk_list_view
    {
        int begin;
        int end;
        int count;
        int total_height;
        nk_context* ctx;
        nk_uint* scroll_pointer;
        nk_uint scroll_value;
    }
    enum nk_widget_layout_states
    {
        NK_WIDGET_INVALID = 0,
        NK_WIDGET_VALID = 1,
        NK_WIDGET_ROM = 2,
    }
    enum NK_WIDGET_INVALID = nk_widget_layout_states.NK_WIDGET_INVALID;
    enum NK_WIDGET_VALID = nk_widget_layout_states.NK_WIDGET_VALID;
    enum NK_WIDGET_ROM = nk_widget_layout_states.NK_WIDGET_ROM;
    enum nk_widget_states
    {
        NK_WIDGET_STATE_MODIFIED = 2,
        NK_WIDGET_STATE_INACTIVE = 4,
        NK_WIDGET_STATE_ENTERED = 8,
        NK_WIDGET_STATE_HOVER = 16,
        NK_WIDGET_STATE_ACTIVED = 32,
        NK_WIDGET_STATE_LEFT = 64,
        NK_WIDGET_STATE_HOVERED = 18,
        NK_WIDGET_STATE_ACTIVE = 34,
    }
    enum NK_WIDGET_STATE_MODIFIED = nk_widget_states.NK_WIDGET_STATE_MODIFIED;
    enum NK_WIDGET_STATE_INACTIVE = nk_widget_states.NK_WIDGET_STATE_INACTIVE;
    enum NK_WIDGET_STATE_ENTERED = nk_widget_states.NK_WIDGET_STATE_ENTERED;
    enum NK_WIDGET_STATE_HOVER = nk_widget_states.NK_WIDGET_STATE_HOVER;
    enum NK_WIDGET_STATE_ACTIVED = nk_widget_states.NK_WIDGET_STATE_ACTIVED;
    enum NK_WIDGET_STATE_LEFT = nk_widget_states.NK_WIDGET_STATE_LEFT;
    enum NK_WIDGET_STATE_HOVERED = nk_widget_states.NK_WIDGET_STATE_HOVERED;
    enum NK_WIDGET_STATE_ACTIVE = nk_widget_states.NK_WIDGET_STATE_ACTIVE;
    int nk_widget_is_hovered(nk_context*) @nogc nothrow;
    enum nk_text_align
    {
        NK_TEXT_ALIGN_LEFT = 1,
        NK_TEXT_ALIGN_CENTERED = 2,
        NK_TEXT_ALIGN_RIGHT = 4,
        NK_TEXT_ALIGN_TOP = 8,
        NK_TEXT_ALIGN_MIDDLE = 16,
        NK_TEXT_ALIGN_BOTTOM = 32,
    }
    enum NK_TEXT_ALIGN_LEFT = nk_text_align.NK_TEXT_ALIGN_LEFT;
    enum NK_TEXT_ALIGN_CENTERED = nk_text_align.NK_TEXT_ALIGN_CENTERED;
    enum NK_TEXT_ALIGN_RIGHT = nk_text_align.NK_TEXT_ALIGN_RIGHT;
    enum NK_TEXT_ALIGN_TOP = nk_text_align.NK_TEXT_ALIGN_TOP;
    enum NK_TEXT_ALIGN_MIDDLE = nk_text_align.NK_TEXT_ALIGN_MIDDLE;
    enum NK_TEXT_ALIGN_BOTTOM = nk_text_align.NK_TEXT_ALIGN_BOTTOM;
    enum nk_text_alignment
    {
        NK_TEXT_LEFT = 17,
        NK_TEXT_CENTERED = 18,
        NK_TEXT_RIGHT = 20,
    }
    enum NK_TEXT_LEFT = nk_text_alignment.NK_TEXT_LEFT;
    enum NK_TEXT_CENTERED = nk_text_alignment.NK_TEXT_CENTERED;
    enum NK_TEXT_RIGHT = nk_text_alignment.NK_TEXT_RIGHT;
    void nk_text_colored(nk_context*, const(char)*, int, nk_flags, nk_color) @nogc nothrow;
    void nk_text_wrap_colored(nk_context*, const(char)*, int, nk_color) @nogc nothrow;
    void nk_labelf_colored(nk_context*, nk_flags, nk_color, const(char)*, ...) @nogc nothrow;
    void nk_labelf_colored_wrap(nk_context*, nk_color, const(char)*, ...) @nogc nothrow;
    void nk_labelfv(nk_context*, nk_flags, const(char)*, int) @nogc nothrow;
    void nk_labelfv_colored(nk_context*, nk_flags, nk_color, const(char)*, int) @nogc nothrow;
    void nk_labelfv_wrap(nk_context*, const(char)*, int) @nogc nothrow;
    void nk_labelfv_colored_wrap(nk_context*, nk_color, const(char)*, int) @nogc nothrow;
    int nk_button_symbol(nk_context*, nk_symbol_type) @nogc nothrow;
    int nk_button_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags) @nogc nothrow;
    int nk_button_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_button_image_label(nk_context*, nk_image, const(char)*, nk_flags) @nogc nothrow;
    int nk_button_text_styled(nk_context*, const(nk_style_button)*, const(char)*, int) @nogc nothrow;
    int nk_button_push_behavior(nk_context*, nk_button_behavior) @nogc nothrow;
    int nk_check_label(nk_context*, const(char)*, int) @nogc nothrow;
    int nk_checkbox_label(nk_context*, const(char)*, int*) @nogc nothrow;
    int nk_checkbox_flags_label(nk_context*, const(char)*, uint*, uint) @nogc nothrow;
    int nk_checkbox_flags_text(nk_context*, const(char)*, int, uint*, uint) @nogc nothrow;
    int nk_option_text(nk_context*, const(char)*, int, int) @nogc nothrow;
    int nk_selectable_label(nk_context*, const(char)*, nk_flags, int*) @nogc nothrow;
    int nk_selectable_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags, int*) @nogc nothrow;
    int nk_select_label(nk_context*, const(char)*, nk_flags, int) @nogc nothrow;
    int nk_select_text(nk_context*, const(char)*, int, nk_flags, int) @nogc nothrow;
    int nk_select_image_text(nk_context*, nk_image, const(char)*, int, nk_flags, int) @nogc nothrow;
    int nk_slider_int(nk_context*, int, int*, int, int) @nogc nothrow;
    nk_size nk_prog(nk_context*, nk_size, nk_size, int) @nogc nothrow;
    void nk_property_int(nk_context*, const(char)*, int, int*, int, int, float) @nogc nothrow;
    void nk_property_float(nk_context*, const(char)*, float, float*, float, float, float) @nogc nothrow;
    enum nk_edit_flags
    {
        NK_EDIT_DEFAULT = 0,
        NK_EDIT_READ_ONLY = 1,
        NK_EDIT_AUTO_SELECT = 2,
        NK_EDIT_SIG_ENTER = 4,
        NK_EDIT_ALLOW_TAB = 8,
        NK_EDIT_NO_CURSOR = 16,
        NK_EDIT_SELECTABLE = 32,
        NK_EDIT_CLIPBOARD = 64,
        NK_EDIT_CTRL_ENTER_NEWLINE = 128,
        NK_EDIT_NO_HORIZONTAL_SCROLL = 256,
        NK_EDIT_ALWAYS_INSERT_MODE = 512,
        NK_EDIT_MULTILINE = 1024,
        NK_EDIT_GOTO_END_ON_ACTIVATE = 2048,
    }
    enum NK_EDIT_DEFAULT = nk_edit_flags.NK_EDIT_DEFAULT;
    enum NK_EDIT_READ_ONLY = nk_edit_flags.NK_EDIT_READ_ONLY;
    enum NK_EDIT_AUTO_SELECT = nk_edit_flags.NK_EDIT_AUTO_SELECT;
    enum NK_EDIT_SIG_ENTER = nk_edit_flags.NK_EDIT_SIG_ENTER;
    enum NK_EDIT_ALLOW_TAB = nk_edit_flags.NK_EDIT_ALLOW_TAB;
    enum NK_EDIT_NO_CURSOR = nk_edit_flags.NK_EDIT_NO_CURSOR;
    enum NK_EDIT_SELECTABLE = nk_edit_flags.NK_EDIT_SELECTABLE;
    enum NK_EDIT_CLIPBOARD = nk_edit_flags.NK_EDIT_CLIPBOARD;
    enum NK_EDIT_CTRL_ENTER_NEWLINE = nk_edit_flags.NK_EDIT_CTRL_ENTER_NEWLINE;
    enum NK_EDIT_NO_HORIZONTAL_SCROLL = nk_edit_flags.NK_EDIT_NO_HORIZONTAL_SCROLL;
    enum NK_EDIT_ALWAYS_INSERT_MODE = nk_edit_flags.NK_EDIT_ALWAYS_INSERT_MODE;
    enum NK_EDIT_MULTILINE = nk_edit_flags.NK_EDIT_MULTILINE;
    enum NK_EDIT_GOTO_END_ON_ACTIVATE = nk_edit_flags.NK_EDIT_GOTO_END_ON_ACTIVATE;
    enum nk_edit_types
    {
        NK_EDIT_SIMPLE = 512,
        NK_EDIT_FIELD = 608,
        NK_EDIT_BOX = 1640,
        NK_EDIT_EDITOR = 1128,
    }
    enum NK_EDIT_SIMPLE = nk_edit_types.NK_EDIT_SIMPLE;
    enum NK_EDIT_FIELD = nk_edit_types.NK_EDIT_FIELD;
    enum NK_EDIT_BOX = nk_edit_types.NK_EDIT_BOX;
    enum NK_EDIT_EDITOR = nk_edit_types.NK_EDIT_EDITOR;
    enum nk_edit_events
    {
        NK_EDIT_ACTIVE = 1,
        NK_EDIT_INACTIVE = 2,
        NK_EDIT_ACTIVATED = 4,
        NK_EDIT_DEACTIVATED = 8,
        NK_EDIT_COMMITED = 16,
    }
    enum NK_EDIT_ACTIVE = nk_edit_events.NK_EDIT_ACTIVE;
    enum NK_EDIT_INACTIVE = nk_edit_events.NK_EDIT_INACTIVE;
    enum NK_EDIT_ACTIVATED = nk_edit_events.NK_EDIT_ACTIVATED;
    enum NK_EDIT_DEACTIVATED = nk_edit_events.NK_EDIT_DEACTIVATED;
    enum NK_EDIT_COMMITED = nk_edit_events.NK_EDIT_COMMITED;
    int nk_chart_begin(nk_context*, nk_chart_type, int, float, float) @nogc nothrow;
    int nk_chart_begin_colored(nk_context*, nk_chart_type, nk_color, nk_color, int, float, float) @nogc nothrow;
    void nk_chart_add_slot_colored(nk_context*, const(nk_chart_type), nk_color, nk_color, int, float, float) @nogc nothrow;
    nk_flags nk_chart_push_slot(nk_context*, float, int) @nogc nothrow;
    void nk_chart_end(nk_context*) @nogc nothrow;
    void nk_plot_function(nk_context*, nk_chart_type, void*, float function(void*, int), int, int) @nogc nothrow;
    int nk_popup_begin(nk_context*, nk_popup_type, const(char)*, nk_flags, nk_rect) @nogc nothrow;
    void nk_combobox_separator(nk_context*, const(char)*, int, int*, int, int, nk_vec2) @nogc nothrow;
    void nk_combobox_callback(nk_context*, void function(void*, int, const(char)**), void*, int*, int, int, nk_vec2) @nogc nothrow;
    int nk_combo_begin_symbol_label(nk_context*, const(char)*, nk_symbol_type, nk_vec2) @nogc nothrow;
    int nk_combo_begin_image_label(nk_context*, const(char)*, nk_image, nk_vec2) @nogc nothrow;
    void nk_combo_close(nk_context*) @nogc nothrow;
    int nk_contextual_item_image_label(nk_context*, nk_image, const(char)*, nk_flags) @nogc nothrow;
    void nk_tooltip(nk_context*, const(char)*) @nogc nothrow;
    void nk_tooltipfv(nk_context*, const(char)*, int) @nogc nothrow;
    void nk_menubar_end(nk_context*) @nogc nothrow;
    int nk_menu_begin_text(nk_context*, const(char)*, int, nk_flags, nk_vec2) @nogc nothrow;
    int nk_menu_begin_image(nk_context*, const(char)*, nk_image, nk_vec2) @nogc nothrow;
    int nk_menu_begin_image_text(nk_context*, const(char)*, int, nk_flags, nk_image, nk_vec2) @nogc nothrow;
    int nk_menu_begin_image_label(nk_context*, const(char)*, nk_flags, nk_image, nk_vec2) @nogc nothrow;
    int nk_menu_begin_symbol(nk_context*, const(char)*, nk_symbol_type, nk_vec2) @nogc nothrow;
    int nk_menu_begin_symbol_text(nk_context*, const(char)*, int, nk_flags, nk_symbol_type, nk_vec2) @nogc nothrow;
    int nk_menu_begin_symbol_label(nk_context*, const(char)*, nk_flags, nk_symbol_type, nk_vec2) @nogc nothrow;
    int nk_menu_item_text(nk_context*, const(char)*, int, nk_flags) @nogc nothrow;
    void nk_menu_close(nk_context*) @nogc nothrow;
    enum nk_style_colors
    {
        NK_COLOR_TEXT = 0,
        NK_COLOR_WINDOW = 1,
        NK_COLOR_HEADER = 2,
        NK_COLOR_BORDER = 3,
        NK_COLOR_BUTTON = 4,
        NK_COLOR_BUTTON_HOVER = 5,
        NK_COLOR_BUTTON_ACTIVE = 6,
        NK_COLOR_TOGGLE = 7,
        NK_COLOR_TOGGLE_HOVER = 8,
        NK_COLOR_TOGGLE_CURSOR = 9,
        NK_COLOR_SELECT = 10,
        NK_COLOR_SELECT_ACTIVE = 11,
        NK_COLOR_SLIDER = 12,
        NK_COLOR_SLIDER_CURSOR = 13,
        NK_COLOR_SLIDER_CURSOR_HOVER = 14,
        NK_COLOR_SLIDER_CURSOR_ACTIVE = 15,
        NK_COLOR_PROPERTY = 16,
        NK_COLOR_EDIT = 17,
        NK_COLOR_EDIT_CURSOR = 18,
        NK_COLOR_COMBO = 19,
        NK_COLOR_CHART = 20,
        NK_COLOR_CHART_COLOR = 21,
        NK_COLOR_CHART_COLOR_HIGHLIGHT = 22,
        NK_COLOR_SCROLLBAR = 23,
        NK_COLOR_SCROLLBAR_CURSOR = 24,
        NK_COLOR_SCROLLBAR_CURSOR_HOVER = 25,
        NK_COLOR_SCROLLBAR_CURSOR_ACTIVE = 26,
        NK_COLOR_TAB_HEADER = 27,
        NK_COLOR_COUNT = 28,
    }
    enum NK_COLOR_TEXT = nk_style_colors.NK_COLOR_TEXT;
    enum NK_COLOR_WINDOW = nk_style_colors.NK_COLOR_WINDOW;
    enum NK_COLOR_HEADER = nk_style_colors.NK_COLOR_HEADER;
    enum NK_COLOR_BORDER = nk_style_colors.NK_COLOR_BORDER;
    enum NK_COLOR_BUTTON = nk_style_colors.NK_COLOR_BUTTON;
    enum NK_COLOR_BUTTON_HOVER = nk_style_colors.NK_COLOR_BUTTON_HOVER;
    enum NK_COLOR_BUTTON_ACTIVE = nk_style_colors.NK_COLOR_BUTTON_ACTIVE;
    enum NK_COLOR_TOGGLE = nk_style_colors.NK_COLOR_TOGGLE;
    enum NK_COLOR_TOGGLE_HOVER = nk_style_colors.NK_COLOR_TOGGLE_HOVER;
    enum NK_COLOR_TOGGLE_CURSOR = nk_style_colors.NK_COLOR_TOGGLE_CURSOR;
    enum NK_COLOR_SELECT = nk_style_colors.NK_COLOR_SELECT;
    enum NK_COLOR_SELECT_ACTIVE = nk_style_colors.NK_COLOR_SELECT_ACTIVE;
    enum NK_COLOR_SLIDER = nk_style_colors.NK_COLOR_SLIDER;
    enum NK_COLOR_SLIDER_CURSOR = nk_style_colors.NK_COLOR_SLIDER_CURSOR;
    enum NK_COLOR_SLIDER_CURSOR_HOVER = nk_style_colors.NK_COLOR_SLIDER_CURSOR_HOVER;
    enum NK_COLOR_SLIDER_CURSOR_ACTIVE = nk_style_colors.NK_COLOR_SLIDER_CURSOR_ACTIVE;
    enum NK_COLOR_PROPERTY = nk_style_colors.NK_COLOR_PROPERTY;
    enum NK_COLOR_EDIT = nk_style_colors.NK_COLOR_EDIT;
    enum NK_COLOR_EDIT_CURSOR = nk_style_colors.NK_COLOR_EDIT_CURSOR;
    enum NK_COLOR_COMBO = nk_style_colors.NK_COLOR_COMBO;
    enum NK_COLOR_CHART = nk_style_colors.NK_COLOR_CHART;
    enum NK_COLOR_CHART_COLOR = nk_style_colors.NK_COLOR_CHART_COLOR;
    enum NK_COLOR_CHART_COLOR_HIGHLIGHT = nk_style_colors.NK_COLOR_CHART_COLOR_HIGHLIGHT;
    enum NK_COLOR_SCROLLBAR = nk_style_colors.NK_COLOR_SCROLLBAR;
    enum NK_COLOR_SCROLLBAR_CURSOR = nk_style_colors.NK_COLOR_SCROLLBAR_CURSOR;
    enum NK_COLOR_SCROLLBAR_CURSOR_HOVER = nk_style_colors.NK_COLOR_SCROLLBAR_CURSOR_HOVER;
    enum NK_COLOR_SCROLLBAR_CURSOR_ACTIVE = nk_style_colors.NK_COLOR_SCROLLBAR_CURSOR_ACTIVE;
    enum NK_COLOR_TAB_HEADER = nk_style_colors.NK_COLOR_TAB_HEADER;
    enum NK_COLOR_COUNT = nk_style_colors.NK_COLOR_COUNT;
    enum nk_style_cursor
    {
        NK_CURSOR_ARROW = 0,
        NK_CURSOR_TEXT = 1,
        NK_CURSOR_MOVE = 2,
        NK_CURSOR_RESIZE_VERTICAL = 3,
        NK_CURSOR_RESIZE_HORIZONTAL = 4,
        NK_CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT = 5,
        NK_CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT = 6,
        NK_CURSOR_COUNT = 7,
    }
    enum NK_CURSOR_ARROW = nk_style_cursor.NK_CURSOR_ARROW;
    enum NK_CURSOR_TEXT = nk_style_cursor.NK_CURSOR_TEXT;
    enum NK_CURSOR_MOVE = nk_style_cursor.NK_CURSOR_MOVE;
    enum NK_CURSOR_RESIZE_VERTICAL = nk_style_cursor.NK_CURSOR_RESIZE_VERTICAL;
    enum NK_CURSOR_RESIZE_HORIZONTAL = nk_style_cursor.NK_CURSOR_RESIZE_HORIZONTAL;
    enum NK_CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT = nk_style_cursor.NK_CURSOR_RESIZE_TOP_LEFT_DOWN_RIGHT;
    enum NK_CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT = nk_style_cursor.NK_CURSOR_RESIZE_TOP_RIGHT_DOWN_LEFT;
    enum NK_CURSOR_COUNT = nk_style_cursor.NK_CURSOR_COUNT;
    void nk_style_from_table(nk_context*, const(nk_color)*) @nogc nothrow;
    int nk_style_set_cursor(nk_context*, nk_style_cursor) @nogc nothrow;
    void nk_style_show_cursor(nk_context*) @nogc nothrow;
    int nk_style_push_font(nk_context*, const(nk_user_font)*) @nogc nothrow;
    int nk_style_push_float(nk_context*, float*, float) @nogc nothrow;
    int nk_style_push_vec2(nk_context*, nk_vec2*, nk_vec2) @nogc nothrow;
    int nk_style_push_style_item(nk_context*, nk_style_item*, nk_style_item) @nogc nothrow;
    int nk_style_pop_font(nk_context*) @nogc nothrow;
    int nk_style_pop_flags(nk_context*) @nogc nothrow;
    int nk_style_pop_color(nk_context*) @nogc nothrow;
    nk_color nk_rgb_f(float, float, float) @nogc nothrow;
    nk_color nk_rgb_fv(const(float)*) @nogc nothrow;
    nk_color nk_rgb_hex(const(char)*) @nogc nothrow;
    nk_color nk_rgba_bv(const(nk_byte)*) @nogc nothrow;
    nk_color nk_rgba_f(float, float, float, float) @nogc nothrow;
    nk_color nk_rgba_fv(const(float)*) @nogc nothrow;
    nk_color nk_rgba_cf(nk_colorf) @nogc nothrow;
    nk_color nk_hsv_bv(const(nk_byte)*) @nogc nothrow;
    void nk_color_f(float*, float*, float*, float*, nk_color) @nogc nothrow;
    nk_uint nk_color_u32(nk_color) @nogc nothrow;
    void nk_color_hex_rgba(char*, nk_color) @nogc nothrow;
    void nk_color_hex_rgb(char*, nk_color) @nogc nothrow;
    void nk_color_hsv_b(nk_byte*, nk_byte*, nk_byte*, nk_color) @nogc nothrow;
    void nk_color_hsv_iv(int*, nk_color) @nogc nothrow;
    void nk_color_hsv_bv(nk_byte*, nk_color) @nogc nothrow;
    void nk_color_hsv_f(float*, float*, float*, nk_color) @nogc nothrow;
    void nk_color_hsva_b(nk_byte*, nk_byte*, nk_byte*, nk_byte*, nk_color) @nogc nothrow;
    void nk_color_hsva_fv(float*, nk_color) @nogc nothrow;
    nk_handle nk_handle_id(int) @nogc nothrow;
    nk_image nk_image_id(int) @nogc nothrow;
    int nk_image_is_subimage(const(nk_image)*) @nogc nothrow;
    void nk_triangle_from_direction(nk_vec2*, nk_rect, float, float, nk_heading) @nogc nothrow;
    pragma(mangle, "nk_vec2") nk_vec2 nk_vec2_(float, float) @nogc nothrow;
    pragma(mangle, "nk_vec2i") nk_vec2 nk_vec2i_(int, int) @nogc nothrow;
    nk_vec2 nk_vec2v(const(float)*) @nogc nothrow;
    nk_vec2 nk_vec2iv(const(int)*) @nogc nothrow;
    pragma(mangle, "nk_rect") nk_rect nk_rect_(float, float, float, float) @nogc nothrow;
    nk_rect nk_rectiv(const(int)*) @nogc nothrow;
    nk_vec2 nk_rect_size(nk_rect) @nogc nothrow;
    int nk_stricmp(const(char)*, const(char)*) @nogc nothrow;
    int nk_strtoi(const(char)*, const(char)**) @nogc nothrow;
    float nk_strtof(const(char)*, const(char)**) @nogc nothrow;
    double nk_strtod(const(char)*, const(char)**) @nogc nothrow;
    int nk_utf_len(const(char)*, int) @nogc nothrow;
    alias nk_text_width_f = float function(nk_handle, float, const(char)*, int);
    alias nk_query_font_glyph_f = void function(nk_handle, float, nk_user_font_glyph*, nk_rune, nk_rune);
    struct nk_user_font_glyph
    {
        nk_vec2[2] uv;
        nk_vec2 offset;
        float width;
        float height;
        float xadvance;
    }
    struct nk_user_font
    {
        nk_handle userdata;
        float height;
        nk_text_width_f width;
        nk_query_font_glyph_f query;
        nk_handle texture;
    }
    enum nk_font_coord_type
    {
        NK_COORD_UV = 0,
        NK_COORD_PIXEL = 1,
    }
    enum NK_COORD_UV = nk_font_coord_type.NK_COORD_UV;
    enum NK_COORD_PIXEL = nk_font_coord_type.NK_COORD_PIXEL;
    struct nk_baked_font
    {
        float height;
        float ascent;
        float descent;
        nk_rune glyph_offset;
        nk_rune glyph_count;
        const(nk_rune)* ranges;
    }
    struct nk_font_config
    {
        nk_font_config* next;
        void* ttf_blob;
        nk_size ttf_size;
        ubyte ttf_data_owned_by_atlas;
        ubyte merge_mode;
        ubyte pixel_snap;
        ubyte oversample_v;
        ubyte oversample_h;
        ubyte[3] padding;
        float size;
        nk_font_coord_type coord_type;
        nk_vec2 spacing;
        const(nk_rune)* range;
        nk_baked_font* font;
        nk_rune fallback_glyph;
        nk_font_config* n;
        nk_font_config* p;
    }
    struct nk_font_glyph
    {
        nk_rune codepoint;
        float xadvance;
        float x0;
        float y0;
        float x1;
        float y1;
        float w;
        float h;
        float u0;
        float v0;
        float u1;
        float v1;
    }
    struct nk_font
    {
        nk_font* next;
        nk_user_font handle;
        nk_baked_font info;
        float scale;
        nk_font_glyph* glyphs;
        const(nk_font_glyph)* fallback;
        nk_rune fallback_codepoint;
        nk_handle texture;
        nk_font_config* config;
    }
    enum nk_font_atlas_format
    {
        NK_FONT_ATLAS_ALPHA8 = 0,
        NK_FONT_ATLAS_RGBA32 = 1,
    }
    enum NK_FONT_ATLAS_ALPHA8 = nk_font_atlas_format.NK_FONT_ATLAS_ALPHA8;
    enum NK_FONT_ATLAS_RGBA32 = nk_font_atlas_format.NK_FONT_ATLAS_RGBA32;
    struct nk_font_atlas
    {
        void* pixel;
        int tex_width;
        int tex_height;
        nk_allocator permanent;
        nk_allocator temporary;
        nk_recti custom;
        nk_cursor[7] cursors;
        int glyph_count;
        nk_font_glyph* glyphs;
        nk_font* default_font;
        nk_font* fonts;
        nk_font_config* config;
        int font_num;
    }
    const(nk_rune)* nk_font_default_glyph_ranges() @nogc nothrow;
    pragma(mangle, "nk_font_config") nk_font_config nk_font_config_(float) @nogc nothrow;
    nk_font* nk_font_atlas_add(nk_font_atlas*, const(nk_font_config)*) @nogc nothrow;
    nk_font* nk_font_atlas_add_default(nk_font_atlas*, float, const(nk_font_config)*) @nogc nothrow;
    nk_font* nk_font_atlas_add_from_memory(nk_font_atlas*, void*, nk_size, float, const(nk_font_config)*) @nogc nothrow;
    nk_font* nk_font_atlas_add_from_file(nk_font_atlas*, const(char)*, float, const(nk_font_config)*) @nogc nothrow;
    nk_font* nk_font_atlas_add_compressed(nk_font_atlas*, void*, nk_size, float, const(nk_font_config)*) @nogc nothrow;
    nk_font* nk_font_atlas_add_compressed_base85(nk_font_atlas*, const(char)*, float, const(nk_font_config)*) @nogc nothrow;
    const(void)* nk_font_atlas_bake(nk_font_atlas*, int*, int*, nk_font_atlas_format) @nogc nothrow;
    struct nk_memory_status
    {
        void* memory;
        uint type;
        nk_size size;
        nk_size allocated;
        nk_size needed;
        nk_size calls;
    }
    enum nk_allocation_type
    {
        NK_BUFFER_FIXED = 0,
        NK_BUFFER_DYNAMIC = 1,
    }
    enum NK_BUFFER_FIXED = nk_allocation_type.NK_BUFFER_FIXED;
    enum NK_BUFFER_DYNAMIC = nk_allocation_type.NK_BUFFER_DYNAMIC;
    enum nk_buffer_allocation_type
    {
        NK_BUFFER_FRONT = 0,
        NK_BUFFER_BACK = 1,
        NK_BUFFER_MAX = 2,
    }
    enum NK_BUFFER_FRONT = nk_buffer_allocation_type.NK_BUFFER_FRONT;
    enum NK_BUFFER_BACK = nk_buffer_allocation_type.NK_BUFFER_BACK;
    enum NK_BUFFER_MAX = nk_buffer_allocation_type.NK_BUFFER_MAX;
    struct nk_buffer_marker
    {
        int active;
        nk_size offset;
    }
    struct nk_memory
    {
        void* ptr;
        nk_size size;
    }
    struct nk_buffer
    {
        nk_buffer_marker[2] marker;
        nk_allocator pool;
        nk_allocation_type type;
        nk_memory memory;
        float grow_factor;
        nk_size allocated;
        nk_size needed;
        nk_size calls;
        nk_size size;
    }
    const(void)* nk_buffer_memory_const(const(nk_buffer)*) @nogc nothrow;
    nk_size nk_buffer_total(nk_buffer*) @nogc nothrow;
    struct nk_str
    {
        nk_buffer buffer;
        int len;
    }
    void nk_str_init_fixed(nk_str*, void*, nk_size) @nogc nothrow;
    int nk_str_insert_text_utf8(nk_str*, int, const(char)*, int) @nogc nothrow;
    int nk_str_insert_str_utf8(nk_str*, int, const(char)*) @nogc nothrow;
    int nk_str_insert_text_runes(nk_str*, int, const(nk_rune)*, int) @nogc nothrow;
    void nk_str_remove_chars(nk_str*, int) @nogc nothrow;
    void nk_str_remove_runes(nk_str*, int) @nogc nothrow;
    void nk_str_delete_chars(nk_str*, int, int) @nogc nothrow;
    void nk_str_delete_runes(nk_str*, int, int) @nogc nothrow;
    char* nk_str_at_char(nk_str*, int) @nogc nothrow;
    const(char)* nk_str_at_char_const(const(nk_str)*, int) @nogc nothrow;
    char* nk_str_get(nk_str*) @nogc nothrow;




    struct nk_clipboard
    {
        nk_handle userdata;
        nk_plugin_paste paste;
        nk_plugin_copy copy;
    }
    struct nk_text_undo_record
    {
        int where;
        short insert_length;
        short delete_length;
        short char_storage;
    }
    struct nk_text_undo_state
    {
        nk_text_undo_record[99] undo_rec;
        nk_rune[999] undo_char;
        short undo_point;
        short redo_point;
        short undo_char_point;
        short redo_char_point;
    }
    enum nk_text_edit_type
    {
        NK_TEXT_EDIT_SINGLE_LINE = 0,
        NK_TEXT_EDIT_MULTI_LINE = 1,
    }
    enum NK_TEXT_EDIT_SINGLE_LINE = nk_text_edit_type.NK_TEXT_EDIT_SINGLE_LINE;
    enum NK_TEXT_EDIT_MULTI_LINE = nk_text_edit_type.NK_TEXT_EDIT_MULTI_LINE;
    enum nk_text_edit_mode
    {
        NK_TEXT_EDIT_MODE_VIEW = 0,
        NK_TEXT_EDIT_MODE_INSERT = 1,
        NK_TEXT_EDIT_MODE_REPLACE = 2,
    }
    enum NK_TEXT_EDIT_MODE_VIEW = nk_text_edit_mode.NK_TEXT_EDIT_MODE_VIEW;
    enum NK_TEXT_EDIT_MODE_INSERT = nk_text_edit_mode.NK_TEXT_EDIT_MODE_INSERT;
    enum NK_TEXT_EDIT_MODE_REPLACE = nk_text_edit_mode.NK_TEXT_EDIT_MODE_REPLACE;
    struct nk_text_edit
    {
        nk_clipboard clip;
        nk_str string;
        nk_plugin_filter filter;
        nk_vec2 scrollbar;
        int cursor;
        int select_start;
        int select_end;
        ubyte mode;
        ubyte cursor_at_end_of_line;
        ubyte initialized;
        ubyte has_preferred_x;
        ubyte single_line;
        ubyte active;
        ubyte padding1;
        float preferred_x;
        nk_text_undo_state undo;
    }
    void nk_textedit_init(nk_text_edit*, nk_allocator*, nk_size) @nogc nothrow;
    void nk_textedit_init_fixed(nk_text_edit*, void*, nk_size) @nogc nothrow;
    void nk_textedit_delete(nk_text_edit*, int, int) @nogc nothrow;
    int nk_textedit_paste(nk_text_edit*, const(char)*, int) @nogc nothrow;
    enum nk_command_type
    {
        NK_COMMAND_NOP = 0,
        NK_COMMAND_SCISSOR = 1,
        NK_COMMAND_LINE = 2,
        NK_COMMAND_CURVE = 3,
        NK_COMMAND_RECT = 4,
        NK_COMMAND_RECT_FILLED = 5,
        NK_COMMAND_RECT_MULTI_COLOR = 6,
        NK_COMMAND_CIRCLE = 7,
        NK_COMMAND_CIRCLE_FILLED = 8,
        NK_COMMAND_ARC = 9,
        NK_COMMAND_ARC_FILLED = 10,
        NK_COMMAND_TRIANGLE = 11,
        NK_COMMAND_TRIANGLE_FILLED = 12,
        NK_COMMAND_POLYGON = 13,
        NK_COMMAND_POLYGON_FILLED = 14,
        NK_COMMAND_POLYLINE = 15,
        NK_COMMAND_TEXT = 16,
        NK_COMMAND_IMAGE = 17,
        NK_COMMAND_CUSTOM = 18,
    }
    enum NK_COMMAND_NOP = nk_command_type.NK_COMMAND_NOP;
    enum NK_COMMAND_SCISSOR = nk_command_type.NK_COMMAND_SCISSOR;
    enum NK_COMMAND_LINE = nk_command_type.NK_COMMAND_LINE;
    enum NK_COMMAND_CURVE = nk_command_type.NK_COMMAND_CURVE;
    enum NK_COMMAND_RECT = nk_command_type.NK_COMMAND_RECT;
    enum NK_COMMAND_RECT_FILLED = nk_command_type.NK_COMMAND_RECT_FILLED;
    enum NK_COMMAND_RECT_MULTI_COLOR = nk_command_type.NK_COMMAND_RECT_MULTI_COLOR;
    enum NK_COMMAND_CIRCLE = nk_command_type.NK_COMMAND_CIRCLE;
    enum NK_COMMAND_CIRCLE_FILLED = nk_command_type.NK_COMMAND_CIRCLE_FILLED;
    enum NK_COMMAND_ARC = nk_command_type.NK_COMMAND_ARC;
    enum NK_COMMAND_ARC_FILLED = nk_command_type.NK_COMMAND_ARC_FILLED;
    enum NK_COMMAND_TRIANGLE = nk_command_type.NK_COMMAND_TRIANGLE;
    enum NK_COMMAND_TRIANGLE_FILLED = nk_command_type.NK_COMMAND_TRIANGLE_FILLED;
    enum NK_COMMAND_POLYGON = nk_command_type.NK_COMMAND_POLYGON;
    enum NK_COMMAND_POLYGON_FILLED = nk_command_type.NK_COMMAND_POLYGON_FILLED;
    enum NK_COMMAND_POLYLINE = nk_command_type.NK_COMMAND_POLYLINE;
    enum NK_COMMAND_TEXT = nk_command_type.NK_COMMAND_TEXT;
    enum NK_COMMAND_IMAGE = nk_command_type.NK_COMMAND_IMAGE;
    enum NK_COMMAND_CUSTOM = nk_command_type.NK_COMMAND_CUSTOM;
    struct nk_command
    {
        nk_command_type type;
        nk_size next;
    }
    struct nk_command_scissor
    {
        nk_command header;
        short x;
        short y;
        ushort w;
        ushort h;
    }
    struct nk_command_line
    {
        nk_command header;
        ushort line_thickness;
        nk_vec2i begin;
        nk_vec2i end;
        nk_color color;
    }
    struct nk_command_curve
    {
        nk_command header;
        ushort line_thickness;
        nk_vec2i begin;
        nk_vec2i end;
        nk_vec2i[2] ctrl;
        nk_color color;
    }
    struct nk_command_rect
    {
        nk_command header;
        ushort rounding;
        ushort line_thickness;
        short x;
        short y;
        ushort w;
        ushort h;
        nk_color color;
    }
    struct nk_command_rect_filled
    {
        nk_command header;
        ushort rounding;
        short x;
        short y;
        ushort w;
        ushort h;
        nk_color color;
    }
    struct nk_command_rect_multi_color
    {
        nk_command header;
        short x;
        short y;
        ushort w;
        ushort h;
        nk_color left;
        nk_color top;
        nk_color bottom;
        nk_color right;
    }
    struct nk_command_triangle
    {
        nk_command header;
        ushort line_thickness;
        nk_vec2i a;
        nk_vec2i b;
        nk_vec2i c;
        nk_color color;
    }
    struct nk_command_triangle_filled
    {
        nk_command header;
        nk_vec2i a;
        nk_vec2i b;
        nk_vec2i c;
        nk_color color;
    }
    struct nk_command_circle
    {
        nk_command header;
        short x;
        short y;
        ushort line_thickness;
        ushort w;
        ushort h;
        nk_color color;
    }
    struct nk_command_circle_filled
    {
        nk_command header;
        short x;
        short y;
        ushort w;
        ushort h;
        nk_color color;
    }
    struct nk_command_arc
    {
        nk_command header;
        short cx;
        short cy;
        ushort r;
        ushort line_thickness;
        float[2] a;
        nk_color color;
    }
    struct nk_command_arc_filled
    {
        nk_command header;
        short cx;
        short cy;
        ushort r;
        float[2] a;
        nk_color color;
    }
    struct nk_command_polygon
    {
        nk_command header;
        nk_color color;
        ushort line_thickness;
        ushort point_count;
        nk_vec2i[1] points;
    }
    struct nk_command_polygon_filled
    {
        nk_command header;
        nk_color color;
        ushort point_count;
        nk_vec2i[1] points;
    }
    struct nk_command_polyline
    {
        nk_command header;
        nk_color color;
        ushort line_thickness;
        ushort point_count;
        nk_vec2i[1] points;
    }
    struct nk_command_image
    {
        nk_command header;
        short x;
        short y;
        ushort w;
        ushort h;
        nk_image img;
        nk_color col;
    }
    alias nk_command_custom_callback = void function(void*, short, short, ushort, ushort, nk_handle);
    struct nk_command_custom
    {
        nk_command header;
        short x;
        short y;
        ushort w;
        ushort h;
        nk_handle callback_data;
        nk_command_custom_callback callback;
    }
    struct nk_command_text
    {
        nk_command header;
        const(nk_user_font)* font;
        nk_color background;
        nk_color foreground;
        short x;
        short y;
        ushort w;
        ushort h;
        float height;
        int length;
        char[1] string;
    }
    enum nk_command_clipping
    {
        NK_CLIPPING_OFF = 0,
        NK_CLIPPING_ON = 1,
    }
    enum NK_CLIPPING_OFF = nk_command_clipping.NK_CLIPPING_OFF;
    enum NK_CLIPPING_ON = nk_command_clipping.NK_CLIPPING_ON;
    struct nk_command_buffer
    {
        nk_buffer* base;
        nk_rect clip;
        int use_clipping;
        nk_handle userdata;
        nk_size begin;
        nk_size end;
        nk_size last;
    }
    void nk_draw_image(nk_command_buffer*, nk_rect, const(nk_image)*, nk_color) @nogc nothrow;
    struct nk_mouse_button
    {
        int down;
        uint clicked;
        nk_vec2 clicked_pos;
    }
    struct nk_mouse
    {
        nk_mouse_button[4] buttons;
        nk_vec2 pos;
        nk_vec2 prev;
        nk_vec2 delta;
        nk_vec2 scroll_delta;
        ubyte grab;
        ubyte grabbed;
        ubyte ungrab;
    }
    struct nk_key
    {
        int down;
        uint clicked;
    }
    struct nk_keyboard
    {
        nk_key[30] keys;
        char[16] text;
        int text_len;
    }
    struct nk_input
    {
        nk_keyboard keyboard;
        nk_mouse mouse;
    }
    int nk_input_has_mouse_click_in_rect(const(nk_input)*, nk_buttons, nk_rect) @nogc nothrow;
    int nk_input_is_mouse_click_down_in_rect(const(nk_input)*, nk_buttons, nk_rect, int) @nogc nothrow;
    int nk_input_is_mouse_released(const(nk_input)*, nk_buttons) @nogc nothrow;
    int nk_input_is_key_pressed(const(nk_input)*, nk_keys) @nogc nothrow;
    int nk_input_is_key_down(const(nk_input)*, nk_keys) @nogc nothrow;
    alias nk_draw_index = ushort;
    enum nk_draw_list_stroke
    {
        NK_STROKE_OPEN = 0,
        NK_STROKE_CLOSED = 1,
    }
    enum NK_STROKE_OPEN = nk_draw_list_stroke.NK_STROKE_OPEN;
    enum NK_STROKE_CLOSED = nk_draw_list_stroke.NK_STROKE_CLOSED;
    enum nk_draw_vertex_layout_attribute
    {
        NK_VERTEX_POSITION = 0,
        NK_VERTEX_COLOR = 1,
        NK_VERTEX_TEXCOORD = 2,
        NK_VERTEX_ATTRIBUTE_COUNT = 3,
    }
    enum NK_VERTEX_POSITION = nk_draw_vertex_layout_attribute.NK_VERTEX_POSITION;
    enum NK_VERTEX_COLOR = nk_draw_vertex_layout_attribute.NK_VERTEX_COLOR;
    enum NK_VERTEX_TEXCOORD = nk_draw_vertex_layout_attribute.NK_VERTEX_TEXCOORD;
    enum NK_VERTEX_ATTRIBUTE_COUNT = nk_draw_vertex_layout_attribute.NK_VERTEX_ATTRIBUTE_COUNT;
    enum nk_draw_vertex_layout_format
    {
        NK_FORMAT_SCHAR = 0,
        NK_FORMAT_SSHORT = 1,
        NK_FORMAT_SINT = 2,
        NK_FORMAT_UCHAR = 3,
        NK_FORMAT_USHORT = 4,
        NK_FORMAT_UINT = 5,
        NK_FORMAT_FLOAT = 6,
        NK_FORMAT_DOUBLE = 7,
        NK_FORMAT_COLOR_BEGIN = 8,
        NK_FORMAT_R8G8B8 = 8,
        NK_FORMAT_R16G15B16 = 9,
        NK_FORMAT_R32G32B32 = 10,
        NK_FORMAT_R8G8B8A8 = 11,
        NK_FORMAT_B8G8R8A8 = 12,
        NK_FORMAT_R16G15B16A16 = 13,
        NK_FORMAT_R32G32B32A32 = 14,
        NK_FORMAT_R32G32B32A32_FLOAT = 15,
        NK_FORMAT_R32G32B32A32_DOUBLE = 16,
        NK_FORMAT_RGB32 = 17,
        NK_FORMAT_RGBA32 = 18,
        NK_FORMAT_COLOR_END = 18,
        NK_FORMAT_COUNT = 19,
    }
    enum NK_FORMAT_SCHAR = nk_draw_vertex_layout_format.NK_FORMAT_SCHAR;
    enum NK_FORMAT_SSHORT = nk_draw_vertex_layout_format.NK_FORMAT_SSHORT;
    enum NK_FORMAT_SINT = nk_draw_vertex_layout_format.NK_FORMAT_SINT;
    enum NK_FORMAT_UCHAR = nk_draw_vertex_layout_format.NK_FORMAT_UCHAR;
    enum NK_FORMAT_USHORT = nk_draw_vertex_layout_format.NK_FORMAT_USHORT;
    enum NK_FORMAT_UINT = nk_draw_vertex_layout_format.NK_FORMAT_UINT;
    enum NK_FORMAT_FLOAT = nk_draw_vertex_layout_format.NK_FORMAT_FLOAT;
    enum NK_FORMAT_DOUBLE = nk_draw_vertex_layout_format.NK_FORMAT_DOUBLE;
    enum NK_FORMAT_COLOR_BEGIN = nk_draw_vertex_layout_format.NK_FORMAT_COLOR_BEGIN;
    enum NK_FORMAT_R8G8B8 = nk_draw_vertex_layout_format.NK_FORMAT_R8G8B8;
    enum NK_FORMAT_R16G15B16 = nk_draw_vertex_layout_format.NK_FORMAT_R16G15B16;
    enum NK_FORMAT_R32G32B32 = nk_draw_vertex_layout_format.NK_FORMAT_R32G32B32;
    enum NK_FORMAT_R8G8B8A8 = nk_draw_vertex_layout_format.NK_FORMAT_R8G8B8A8;
    enum NK_FORMAT_B8G8R8A8 = nk_draw_vertex_layout_format.NK_FORMAT_B8G8R8A8;
    enum NK_FORMAT_R16G15B16A16 = nk_draw_vertex_layout_format.NK_FORMAT_R16G15B16A16;
    enum NK_FORMAT_R32G32B32A32 = nk_draw_vertex_layout_format.NK_FORMAT_R32G32B32A32;
    enum NK_FORMAT_R32G32B32A32_FLOAT = nk_draw_vertex_layout_format.NK_FORMAT_R32G32B32A32_FLOAT;
    enum NK_FORMAT_R32G32B32A32_DOUBLE = nk_draw_vertex_layout_format.NK_FORMAT_R32G32B32A32_DOUBLE;
    enum NK_FORMAT_RGB32 = nk_draw_vertex_layout_format.NK_FORMAT_RGB32;
    enum NK_FORMAT_RGBA32 = nk_draw_vertex_layout_format.NK_FORMAT_RGBA32;
    enum NK_FORMAT_COLOR_END = nk_draw_vertex_layout_format.NK_FORMAT_COLOR_END;
    enum NK_FORMAT_COUNT = nk_draw_vertex_layout_format.NK_FORMAT_COUNT;


    struct nk_draw_vertex_layout_element
    {
        nk_draw_vertex_layout_attribute attribute;
        nk_draw_vertex_layout_format format;
        nk_size offset;
    }
    struct nk_draw_command
    {
        uint elem_count;
        nk_rect clip_rect;
        nk_handle texture;
    }
    struct nk_draw_list
    {
        nk_rect clip_rect;
        nk_vec2[12] circle_vtx;
        nk_convert_config config;
        nk_buffer* buffer;
        nk_buffer* vertices;
        nk_buffer* elements;
        uint element_count;
        uint vertex_count;
        uint cmd_count;
        nk_size cmd_offset;
        uint path_count;
        uint path_offset;
        nk_anti_aliasing line_AA;
        nk_anti_aliasing shape_AA;
    }
    void nk_draw_list_init(nk_draw_list*) @nogc nothrow;


    void nk_draw_list_path_clear(nk_draw_list*) @nogc nothrow;
    void nk_draw_list_path_line_to(nk_draw_list*, nk_vec2) @nogc nothrow;
    void nk_draw_list_path_rect_to(nk_draw_list*, nk_vec2, nk_vec2, float) @nogc nothrow;
    void nk_draw_list_path_curve_to(nk_draw_list*, nk_vec2, nk_vec2, nk_vec2, uint) @nogc nothrow;
    void nk_draw_list_path_fill(nk_draw_list*, nk_color) @nogc nothrow;
    void nk_draw_list_stroke_line(nk_draw_list*, nk_vec2, nk_vec2, nk_color, float) @nogc nothrow;
    void nk_draw_list_stroke_rect(nk_draw_list*, nk_rect, nk_color, float, float) @nogc nothrow;
    void nk_draw_list_stroke_triangle(nk_draw_list*, nk_vec2, nk_vec2, nk_vec2, nk_color, float) @nogc nothrow;
    void nk_draw_list_stroke_curve(nk_draw_list*, nk_vec2, nk_vec2, nk_vec2, nk_vec2, nk_color, uint, float) @nogc nothrow;
    enum nk_style_item_type
    {
        NK_STYLE_ITEM_COLOR = 0,
        NK_STYLE_ITEM_IMAGE = 1,
    }
    enum NK_STYLE_ITEM_COLOR = nk_style_item_type.NK_STYLE_ITEM_COLOR;
    enum NK_STYLE_ITEM_IMAGE = nk_style_item_type.NK_STYLE_ITEM_IMAGE;
    union nk_style_item_data
    {
        nk_image image;
        nk_color color;
    }
    struct nk_style_item
    {
        nk_style_item_type type;
        nk_style_item_data data;
    }
    struct nk_style_text
    {
        nk_color color;
        nk_vec2 padding;
    }
    struct nk_style_button
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_color text_background;
        nk_color text_normal;
        nk_color text_hover;
        nk_color text_active;
        nk_flags text_alignment;
        float border;
        float rounding;
        nk_vec2 padding;
        nk_vec2 image_padding;
        nk_vec2 touch_padding;
        nk_handle userdata;
        void function(nk_command_buffer*, nk_handle) draw_begin;
        void function(nk_command_buffer*, nk_handle) draw_end;
    }
    struct nk_style_toggle
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_style_item cursor_normal;
        nk_style_item cursor_hover;
        nk_color text_normal;
        nk_color text_hover;
        nk_color text_active;
        nk_color text_background;
        nk_flags text_alignment;
        nk_vec2 padding;
        nk_vec2 touch_padding;
        float spacing;
        float border;
        nk_handle userdata;
        void function(nk_command_buffer*, nk_handle) draw_begin;
        void function(nk_command_buffer*, nk_handle) draw_end;
    }
    struct nk_style_selectable
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item pressed;
        nk_style_item normal_active;
        nk_style_item hover_active;
        nk_style_item pressed_active;
        nk_color text_normal;
        nk_color text_hover;
        nk_color text_pressed;
        nk_color text_normal_active;
        nk_color text_hover_active;
        nk_color text_pressed_active;
        nk_color text_background;
        nk_flags text_alignment;
        float rounding;
        nk_vec2 padding;
        nk_vec2 touch_padding;
        nk_vec2 image_padding;
        nk_handle userdata;
        void function(nk_command_buffer*, nk_handle) draw_begin;
        void function(nk_command_buffer*, nk_handle) draw_end;
    }
    struct nk_style_slider
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_color bar_normal;
        nk_color bar_hover;
        nk_color bar_active;
        nk_color bar_filled;
        nk_style_item cursor_normal;
        nk_style_item cursor_hover;
        nk_style_item cursor_active;
        float border;
        float rounding;
        float bar_height;
        nk_vec2 padding;
        nk_vec2 spacing;
        nk_vec2 cursor_size;
        int show_buttons;
        nk_style_button inc_button;
        nk_style_button dec_button;
        nk_symbol_type inc_symbol;
        nk_symbol_type dec_symbol;
        nk_handle userdata;
        void function(nk_command_buffer*, nk_handle) draw_begin;
        void function(nk_command_buffer*, nk_handle) draw_end;
    }
    struct nk_style_progress
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_style_item cursor_normal;
        nk_style_item cursor_hover;
        nk_style_item cursor_active;
        nk_color cursor_border_color;
        float rounding;
        float border;
        float cursor_border;
        float cursor_rounding;
        nk_vec2 padding;
        nk_handle userdata;
        void function(nk_command_buffer*, nk_handle) draw_begin;
        void function(nk_command_buffer*, nk_handle) draw_end;
    }
    struct nk_style_scrollbar
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_style_item cursor_normal;
        nk_style_item cursor_hover;
        nk_style_item cursor_active;
        nk_color cursor_border_color;
        float border;
        float rounding;
        float border_cursor;
        float rounding_cursor;
        nk_vec2 padding;
        int show_buttons;
        nk_style_button inc_button;
        nk_style_button dec_button;
        nk_symbol_type inc_symbol;
        nk_symbol_type dec_symbol;
        nk_handle userdata;
        void function(nk_command_buffer*, nk_handle) draw_begin;
        void function(nk_command_buffer*, nk_handle) draw_end;
    }
    struct nk_style_edit
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_style_scrollbar scrollbar;
        nk_color cursor_normal;
        nk_color cursor_hover;
        nk_color cursor_text_normal;
        nk_color cursor_text_hover;
        nk_color text_normal;
        nk_color text_hover;
        nk_color text_active;
        nk_color selected_normal;
        nk_color selected_hover;
        nk_color selected_text_normal;
        nk_color selected_text_hover;
        float border;
        float rounding;
        float cursor_size;
        nk_vec2 scrollbar_size;
        nk_vec2 padding;
        float row_padding;
    }
    struct nk_style_property
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_color label_normal;
        nk_color label_hover;
        nk_color label_active;
        nk_symbol_type sym_left;
        nk_symbol_type sym_right;
        float border;
        float rounding;
        nk_vec2 padding;
        nk_style_edit edit;
        nk_style_button inc_button;
        nk_style_button dec_button;
        nk_handle userdata;
        void function(nk_command_buffer*, nk_handle) draw_begin;
        void function(nk_command_buffer*, nk_handle) draw_end;
    }
    struct nk_style_chart
    {
        nk_style_item background;
        nk_color border_color;
        nk_color selected_color;
        nk_color color;
        float border;
        float rounding;
        nk_vec2 padding;
    }
    struct nk_style_combo
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_color border_color;
        nk_color label_normal;
        nk_color label_hover;
        nk_color label_active;
        nk_color symbol_normal;
        nk_color symbol_hover;
        nk_color symbol_active;
        nk_style_button button;
        nk_symbol_type sym_normal;
        nk_symbol_type sym_hover;
        nk_symbol_type sym_active;
        float border;
        float rounding;
        nk_vec2 content_padding;
        nk_vec2 button_padding;
        nk_vec2 spacing;
    }
    struct nk_style_tab
    {
        nk_style_item background;
        nk_color border_color;
        nk_color text;
        nk_style_button tab_maximize_button;
        nk_style_button tab_minimize_button;
        nk_style_button node_maximize_button;
        nk_style_button node_minimize_button;
        nk_symbol_type sym_minimize;
        nk_symbol_type sym_maximize;
        float border;
        float rounding;
        float indent;
        nk_vec2 padding;
        nk_vec2 spacing;
    }
    enum nk_style_header_align
    {
        NK_HEADER_LEFT = 0,
        NK_HEADER_RIGHT = 1,
    }
    enum NK_HEADER_LEFT = nk_style_header_align.NK_HEADER_LEFT;
    enum NK_HEADER_RIGHT = nk_style_header_align.NK_HEADER_RIGHT;
    struct nk_style_window_header
    {
        nk_style_item normal;
        nk_style_item hover;
        nk_style_item active;
        nk_style_button close_button;
        nk_style_button minimize_button;
        nk_symbol_type close_symbol;
        nk_symbol_type minimize_symbol;
        nk_symbol_type maximize_symbol;
        nk_color label_normal;
        nk_color label_hover;
        nk_color label_active;
        nk_style_header_align align_;
        nk_vec2 padding;
        nk_vec2 label_padding;
        nk_vec2 spacing;
    }
    struct nk_style_window
    {
        nk_style_window_header header;
        nk_style_item fixed_background;
        nk_color background;
        nk_color border_color;
        nk_color popup_border_color;
        nk_color combo_border_color;
        nk_color contextual_border_color;
        nk_color menu_border_color;
        nk_color group_border_color;
        nk_color tooltip_border_color;
        nk_style_item scaler;
        float border;
        float combo_border;
        float contextual_border;
        float menu_border;
        float group_border;
        float tooltip_border;
        float popup_border;
        float min_row_height_padding;
        float rounding;
        nk_vec2 spacing;
        nk_vec2 scrollbar_size;
        nk_vec2 min_size;
        nk_vec2 padding;
        nk_vec2 group_padding;
        nk_vec2 popup_padding;
        nk_vec2 combo_padding;
        nk_vec2 contextual_padding;
        nk_vec2 menu_padding;
        nk_vec2 tooltip_padding;
    }
    struct nk_style
    {
        const(nk_user_font)* font;
        const(nk_cursor)*[7] cursors;
        const(nk_cursor)* cursor_active;
        nk_cursor* cursor_last;
        int cursor_visible;
        nk_style_text text;
        nk_style_button button;
        nk_style_button contextual_button;
        nk_style_button menu_button;
        nk_style_toggle option;
        nk_style_toggle checkbox;
        nk_style_selectable selectable;
        nk_style_slider slider;
        nk_style_progress progress;
        nk_style_property property;
        nk_style_edit edit;
        nk_style_chart chart;
        nk_style_scrollbar scrollh;
        nk_style_scrollbar scrollv;
        nk_style_tab tab;
        nk_style_combo combo;
        nk_style_window window;
    }
    nk_style_item nk_style_item_image(nk_image) @nogc nothrow;




    enum nk_panel_type
    {
        NK_PANEL_NONE = 0,
        NK_PANEL_WINDOW = 1,
        NK_PANEL_GROUP = 2,
        NK_PANEL_POPUP = 4,
        NK_PANEL_CONTEXTUAL = 16,
        NK_PANEL_COMBO = 32,
        NK_PANEL_MENU = 64,
        NK_PANEL_TOOLTIP = 128,
    }
    enum NK_PANEL_NONE = nk_panel_type.NK_PANEL_NONE;
    enum NK_PANEL_WINDOW = nk_panel_type.NK_PANEL_WINDOW;
    enum NK_PANEL_GROUP = nk_panel_type.NK_PANEL_GROUP;
    enum NK_PANEL_POPUP = nk_panel_type.NK_PANEL_POPUP;
    enum NK_PANEL_CONTEXTUAL = nk_panel_type.NK_PANEL_CONTEXTUAL;
    enum NK_PANEL_COMBO = nk_panel_type.NK_PANEL_COMBO;
    enum NK_PANEL_MENU = nk_panel_type.NK_PANEL_MENU;
    enum NK_PANEL_TOOLTIP = nk_panel_type.NK_PANEL_TOOLTIP;
    enum nk_panel_set
    {
        NK_PANEL_SET_NONBLOCK = 240,
        NK_PANEL_SET_POPUP = 244,
        NK_PANEL_SET_SUB = 246,
    }
    enum NK_PANEL_SET_NONBLOCK = nk_panel_set.NK_PANEL_SET_NONBLOCK;
    enum NK_PANEL_SET_POPUP = nk_panel_set.NK_PANEL_SET_POPUP;
    enum NK_PANEL_SET_SUB = nk_panel_set.NK_PANEL_SET_SUB;
    struct nk_chart_slot
    {
        nk_chart_type type;
        nk_color color;
        nk_color highlight;
        float min;
        float max;
        float range;
        int count;
        nk_vec2 last;
        int index;
    }
    struct nk_chart
    {
        int slot;
        float x;
        float y;
        float w;
        float h;
        nk_chart_slot[4] slots;
    }
    enum nk_panel_row_layout_type
    {
        NK_LAYOUT_DYNAMIC_FIXED = 0,
        NK_LAYOUT_DYNAMIC_ROW = 1,
        NK_LAYOUT_DYNAMIC_FREE = 2,
        NK_LAYOUT_DYNAMIC = 3,
        NK_LAYOUT_STATIC_FIXED = 4,
        NK_LAYOUT_STATIC_ROW = 5,
        NK_LAYOUT_STATIC_FREE = 6,
        NK_LAYOUT_STATIC = 7,
        NK_LAYOUT_TEMPLATE = 8,
        NK_LAYOUT_COUNT = 9,
    }
    enum NK_LAYOUT_DYNAMIC_FIXED = nk_panel_row_layout_type.NK_LAYOUT_DYNAMIC_FIXED;
    enum NK_LAYOUT_DYNAMIC_ROW = nk_panel_row_layout_type.NK_LAYOUT_DYNAMIC_ROW;
    enum NK_LAYOUT_DYNAMIC_FREE = nk_panel_row_layout_type.NK_LAYOUT_DYNAMIC_FREE;
    enum NK_LAYOUT_DYNAMIC = nk_panel_row_layout_type.NK_LAYOUT_DYNAMIC;
    enum NK_LAYOUT_STATIC_FIXED = nk_panel_row_layout_type.NK_LAYOUT_STATIC_FIXED;
    enum NK_LAYOUT_STATIC_ROW = nk_panel_row_layout_type.NK_LAYOUT_STATIC_ROW;
    enum NK_LAYOUT_STATIC_FREE = nk_panel_row_layout_type.NK_LAYOUT_STATIC_FREE;
    enum NK_LAYOUT_STATIC = nk_panel_row_layout_type.NK_LAYOUT_STATIC;
    enum NK_LAYOUT_TEMPLATE = nk_panel_row_layout_type.NK_LAYOUT_TEMPLATE;
    enum NK_LAYOUT_COUNT = nk_panel_row_layout_type.NK_LAYOUT_COUNT;
    struct nk_row_layout
    {
        nk_panel_row_layout_type type;
        int index;
        float height;
        float min_height;
        int columns;
        const(float)* ratio;
        float item_width;
        float item_height;
        float item_offset;
        float filled;
        nk_rect item;
        int tree_depth;
        float[16] templates;
    }
    struct nk_popup_buffer
    {
        nk_size begin;
        nk_size parent;
        nk_size last;
        nk_size end;
        int active;
    }
    struct nk_menu_state
    {
        float x;
        float y;
        float w;
        float h;
        nk_scroll offset;
    }
    struct nk_panel
    {
        nk_panel_type type;
        nk_flags flags;
        nk_rect bounds;
        nk_uint* offset_x;
        nk_uint* offset_y;
        float at_x;
        float at_y;
        float max_x;
        float footer_height;
        float header_height;
        float border;
        uint has_scrolling;
        nk_rect clip;
        nk_menu_state menu;
        nk_row_layout row;
        nk_chart chart;
        nk_command_buffer* buffer;
        nk_panel* parent;
    }


    enum nk_window_flags
    {
        NK_WINDOW_PRIVATE = 2048,
        NK_WINDOW_DYNAMIC = 2048,
        NK_WINDOW_ROM = 4096,
        NK_WINDOW_NOT_INTERACTIVE = 5120,
        NK_WINDOW_HIDDEN = 8192,
        NK_WINDOW_CLOSED = 16384,
        NK_WINDOW_MINIMIZED = 32768,
        NK_WINDOW_REMOVE_ROM = 65536,
    }
    enum NK_WINDOW_PRIVATE = nk_window_flags.NK_WINDOW_PRIVATE;
    enum NK_WINDOW_DYNAMIC = nk_window_flags.NK_WINDOW_DYNAMIC;
    enum NK_WINDOW_ROM = nk_window_flags.NK_WINDOW_ROM;
    enum NK_WINDOW_NOT_INTERACTIVE = nk_window_flags.NK_WINDOW_NOT_INTERACTIVE;
    enum NK_WINDOW_HIDDEN = nk_window_flags.NK_WINDOW_HIDDEN;
    enum NK_WINDOW_CLOSED = nk_window_flags.NK_WINDOW_CLOSED;
    enum NK_WINDOW_MINIMIZED = nk_window_flags.NK_WINDOW_MINIMIZED;
    enum NK_WINDOW_REMOVE_ROM = nk_window_flags.NK_WINDOW_REMOVE_ROM;
    struct nk_popup_state
    {
        nk_window* win;
        nk_panel_type type;
        nk_popup_buffer buf;
        nk_hash name;
        int active;
        uint combo_count;
        uint con_count;
        uint con_old;
        uint active_con;
        nk_rect header;
    }
    struct nk_edit_state
    {
        nk_hash name;
        uint seq;
        uint old;
        int active;
        int prev;
        int cursor;
        int sel_start;
        int sel_end;
        nk_scroll scrollbar;
        ubyte mode;
        ubyte single_line;
    }
    struct nk_property_state
    {
        int active;
        int prev;
        char[64] buffer;
        int length;
        int cursor;
        int select_start;
        int select_end;
        nk_hash name;
        uint seq;
        uint old;
        int state;
    }
    struct nk_window
    {
        uint seq;
        nk_hash name;
        char[64] name_string;
        nk_flags flags;
        nk_rect bounds;
        nk_scroll scrollbar;
        nk_command_buffer buffer;
        nk_panel* layout;
        float scrollbar_hiding_timer;
        nk_property_state property;
        nk_popup_state popup;
        nk_edit_state edit;
        uint scrolled;
        nk_table* tables;
        uint table_count;
        nk_window* next;
        nk_window* prev;
        nk_window* parent;
    }
    struct nk_config_stack_style_item_element
    {
        nk_style_item* address;
        nk_style_item old_value;
    }
    struct nk_config_stack_float_element
    {
        float* address;
        float old_value;
    }
    struct nk_config_stack_vec2_element
    {
        nk_vec2* address;
        nk_vec2 old_value;
    }
    struct nk_config_stack_flags_element
    {
        nk_flags* address;
        nk_flags old_value;
    }
    struct nk_config_stack_color_element
    {
        nk_color* address;
        nk_color old_value;
    }
    struct nk_config_stack_user_font_element
    {
        const(nk_user_font)** address;
        const(nk_user_font)* old_value;
    }
    struct nk_config_stack_button_behavior_element
    {
        nk_button_behavior* address;
        nk_button_behavior old_value;
    }
    struct nk_config_stack_style_item
    {
        int head;
        nk_config_stack_style_item_element[16] elements;
    }
    struct nk_config_stack_float
    {
        int head;
        nk_config_stack_float_element[32] elements;
    }
    struct nk_config_stack_vec2
    {
        int head;
        nk_config_stack_vec2_element[16] elements;
    }
    struct nk_config_stack_flags
    {
        int head;
        nk_config_stack_flags_element[32] elements;
    }
    struct nk_config_stack_color
    {
        int head;
        nk_config_stack_color_element[32] elements;
    }
    struct nk_config_stack_user_font
    {
        int head;
        nk_config_stack_user_font_element[8] elements;
    }
    struct nk_config_stack_button_behavior
    {
        int head;
        nk_config_stack_button_behavior_element[8] elements;
    }
    struct nk_configuration_stacks
    {
        nk_config_stack_style_item style_items;
        nk_config_stack_float floats;
        nk_config_stack_vec2 vectors;
        nk_config_stack_flags flags;
        nk_config_stack_color colors;
        nk_config_stack_user_font fonts;
        nk_config_stack_button_behavior button_behaviors;
    }



    struct nk_table
    {
        uint seq;
        uint size;
        nk_hash[59] keys;
        nk_uint[59] values;
        nk_table* next;
        nk_table* prev;
    }
    union nk_page_data
    {
        nk_table tbl;
        nk_panel pan;
        nk_window win;
    }
    struct nk_page_element
    {
        nk_page_data data;
        nk_page_element* next;
        nk_page_element* prev;
    }
    struct nk_page
    {
        uint size;
        nk_page* next;
        nk_page_element[1] win;
    }
    struct nk_pool
    {
        nk_allocator alloc;
        nk_allocation_type type;
        uint page_count;
        nk_page* pages;
        nk_page_element* freelist;
        uint capacity;
        nk_size size;
        nk_size cap;
    }
    struct nk_context
    {
        nk_input input;
        nk_style style;
        nk_buffer memory;
        nk_clipboard clip;
        nk_flags last_widget_state;
        nk_button_behavior button_behavior;
        nk_configuration_stacks stacks;
        float delta_time_seconds;
        nk_draw_list draw_list;
        nk_text_edit text_edit;
        nk_command_buffer overlay;
        int build;
        int use_pool;
        nk_pool pool;
        nk_window* begin;
        nk_window* end;
        nk_window* active;
        nk_window* current;
        nk_page_element* freelist;
        uint count;
        uint seq;
    }
    alias _dummy_array5693 = char[1];
    alias _dummy_array5694 = char[1];
    alias _dummy_array5695 = char[1];
    alias _dummy_array5696 = char[1];
    alias _dummy_array5697 = char[1];
    alias _dummy_array5698 = char[1];
    alias _dummy_array5699 = char[1];
    alias _dummy_array5700 = char[1];
    alias _dummy_array5701 = char[1];
    extern __gshared const(nk_rect) nk_null_rect;


    extern __gshared const(nk_color) nk_red;
    extern __gshared const(nk_color) nk_green;
    extern __gshared const(nk_color) nk_blue;
    extern __gshared const(nk_color) nk_white;
    extern __gshared const(nk_color) nk_black;
    extern __gshared const(nk_color) nk_yellow;





    static float nk_sin(float) @nogc nothrow;
    static int nk_log10(double) @nogc nothrow;
    static int nk_is_lower(int) @nogc nothrow;
    static int nk_is_upper(int) @nogc nothrow;
    static int nk_to_upper(int) @nogc nothrow;
    static int nk_to_lower(int) @nogc nothrow;
    static void* nk_memcopy(void*, const(void)*, nk_size) @nogc nothrow;
    static void nk_zero(void*, nk_size) @nogc nothrow;
    static int nk_string_float_limit(char*, int) @nogc nothrow;
    static char* nk_dtoa(char*, double) @nogc nothrow;
    static int nk_text_clamp(const(nk_user_font)*, const(char)*, int, float, int*, float*, nk_rune*, int) @nogc nothrow;
    static nk_vec2 nk_text_calculate_text_bounds(const(nk_user_font)*, const(char)*, int, float, const(char)**, nk_vec2*, int*, int) @nogc nothrow;
    static int nk_strfmt(char*, int, const(char)*, va_list) @nogc nothrow;
    static void nk_start(nk_context*, nk_window*) @nogc nothrow;
    static void nk_finish_buffer(nk_context*, nk_command_buffer*) @nogc nothrow;
    static void nk_build(nk_context*) @nogc nothrow;
    static void nk_textedit_drag(nk_text_edit*, float, float, const(nk_user_font)*, float) @nogc nothrow;
    static void nk_textedit_key(nk_text_edit*, nk_keys, int, const(nk_user_font)*, float) @nogc nothrow;
    enum nk_window_insert_location
    {
        NK_INSERT_BACK = 0,
        NK_INSERT_FRONT = 1,
    }
    enum NK_INSERT_BACK = nk_window_insert_location.NK_INSERT_BACK;
    enum NK_INSERT_FRONT = nk_window_insert_location.NK_INSERT_FRONT;
    static void nk_remove_window(nk_context*, nk_window*) @nogc nothrow;
    static nk_page_element* nk_pool_alloc(nk_pool*) @nogc nothrow;
    static void nk_link_page_element_into_freelist(nk_context*, nk_page_element*) @nogc nothrow;
    static nk_table* nk_create_table(nk_context*) @nogc nothrow;
    static void nk_remove_table(nk_window*, nk_table*) @nogc nothrow;
    static void nk_free_table(nk_context*, nk_table*) @nogc nothrow;
    static void nk_push_table(nk_window*, nk_table*) @nogc nothrow;
    static nk_uint* nk_add_value(nk_context*, nk_window*, nk_hash, nk_uint) @nogc nothrow;
    static int nk_panel_is_nonblock(nk_panel_type) @nogc nothrow;
    static void nk_panel_alloc_space(nk_rect*, const(nk_context)*) @nogc nothrow;
    static void nk_layout_peek(nk_rect*, nk_context*) @nogc nothrow;
    struct nk_text
    {
        nk_vec2 padding;
        nk_color background;
        nk_color text;
    }
    static void nk_widget_text_wrap(nk_command_buffer*, nk_rect, const(char)*, int, const(nk_text)*, const(nk_user_font)*) @nogc nothrow;
    static const(nk_style_item)* nk_draw_button(nk_command_buffer*, const(nk_rect)*, nk_flags, const(nk_style_button)*) @nogc nothrow;
    static int nk_do_button(nk_flags*, nk_command_buffer*, nk_rect, const(nk_style_button)*, const(nk_input)*, nk_button_behavior, nk_rect*) @nogc nothrow;
    static void nk_draw_button_text(nk_command_buffer*, const(nk_rect)*, const(nk_rect)*, nk_flags, const(nk_style_button)*, const(char)*, int, nk_flags, const(nk_user_font)*) @nogc nothrow;
    static int nk_do_button_text(nk_flags*, nk_command_buffer*, nk_rect, const(char)*, int, nk_flags, nk_button_behavior, const(nk_style_button)*, const(nk_input)*, const(nk_user_font)*) @nogc nothrow;
    static void nk_draw_button_symbol(nk_command_buffer*, const(nk_rect)*, const(nk_rect)*, nk_flags, const(nk_style_button)*, nk_symbol_type, const(nk_user_font)*) @nogc nothrow;
    static void nk_draw_button_image(nk_command_buffer*, const(nk_rect)*, const(nk_rect)*, nk_flags, const(nk_style_button)*, const(nk_image)*) @nogc nothrow;
    static int nk_do_button_text_symbol(nk_flags*, nk_command_buffer*, nk_rect, nk_symbol_type, const(char)*, int, nk_flags, nk_button_behavior, const(nk_style_button)*, const(nk_user_font)*, const(nk_input)*) @nogc nothrow;
    static void nk_draw_button_text_image(nk_command_buffer*, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, nk_flags, const(nk_style_button)*, const(char)*, int, const(nk_user_font)*, const(nk_image)*) @nogc nothrow;
    static int nk_do_button_text_image(nk_flags*, nk_command_buffer*, nk_rect, nk_image, const(char)*, int, nk_flags, nk_button_behavior, const(nk_style_button)*, const(nk_user_font)*, const(nk_input)*) @nogc nothrow;
    enum nk_toggle_type
    {
        NK_TOGGLE_CHECK = 0,
        NK_TOGGLE_OPTION = 1,
    }
    enum NK_TOGGLE_CHECK = nk_toggle_type.NK_TOGGLE_CHECK;
    enum NK_TOGGLE_OPTION = nk_toggle_type.NK_TOGGLE_OPTION;
    static nk_size nk_progress_behavior(nk_flags*, nk_input*, nk_rect, nk_rect, nk_size, nk_size, int) @nogc nothrow;
    static float nk_slider_behavior(nk_flags*, nk_rect*, nk_rect*, nk_input*, nk_rect, float, float, float, float, float) @nogc nothrow;
    static float nk_do_slider(nk_flags*, nk_command_buffer*, nk_rect, float, float, float, float, const(nk_style_slider)*, nk_input*, const(nk_user_font)*) @nogc nothrow;
    static void nk_draw_selectable(nk_command_buffer*, nk_flags, const(nk_style_selectable)*, int, const(nk_rect)*, const(nk_rect)*, const(nk_image)*, nk_symbol_type, const(char)*, int, nk_flags, const(nk_user_font)*) @nogc nothrow;
    enum nk_property_status
    {
        NK_PROPERTY_DEFAULT = 0,
        NK_PROPERTY_EDIT = 1,
        NK_PROPERTY_DRAG = 2,
    }
    enum NK_PROPERTY_DEFAULT = nk_property_status.NK_PROPERTY_DEFAULT;
    enum NK_PROPERTY_EDIT = nk_property_status.NK_PROPERTY_EDIT;
    enum NK_PROPERTY_DRAG = nk_property_status.NK_PROPERTY_DRAG;
    enum nk_property_filter
    {
        NK_FILTER_INT = 0,
        NK_FILTER_FLOAT = 1,
    }
    enum NK_FILTER_INT = nk_property_filter.NK_FILTER_INT;
    enum NK_FILTER_FLOAT = nk_property_filter.NK_FILTER_FLOAT;
    enum nk_property_kind
    {
        NK_PROPERTY_INT = 0,
        NK_PROPERTY_FLOAT = 1,
        NK_PROPERTY_DOUBLE = 2,
    }
    enum NK_PROPERTY_INT = nk_property_kind.NK_PROPERTY_INT;
    enum NK_PROPERTY_FLOAT = nk_property_kind.NK_PROPERTY_FLOAT;
    enum NK_PROPERTY_DOUBLE = nk_property_kind.NK_PROPERTY_DOUBLE;
    union nk_property
    {
        int i;
        float f;
        double d;
    }
    struct nk_property_variant
    {
        nk_property_kind kind;
        nk_property value;
        nk_property min_value;
        nk_property max_value;
        nk_property step;
    }
    static void nk_draw_property(nk_command_buffer*, const(nk_style_property)*, const(nk_rect)*, const(nk_rect)*, nk_flags, const(char)*, int, const(nk_user_font)*) @nogc nothrow;
    static float nk_inv_sqrt(float) @nogc nothrow;
    static float nk_sqrt(float) @nogc nothrow;
    static float nk_cos(float) @nogc nothrow;
    static nk_uint nk_round_up_pow2(nk_uint) @nogc nothrow;
    static double nk_pow(double, int) @nogc nothrow;
    static int nk_ifloord(double) @nogc nothrow;
    static int nk_ifloorf(float) @nogc nothrow;
    static int nk_iceilf(float) @nogc nothrow;
    nk_rect nk_get_null_rect() @nogc nothrow;
    pragma(mangle, "nk_recti") nk_rect nk_recti_(int, int, int, int) @nogc nothrow;
    nk_rect nk_recta(nk_vec2, nk_vec2) @nogc nothrow;
    nk_rect nk_rectv(const(float)*) @nogc nothrow;
    nk_vec2 nk_rect_pos(nk_rect) @nogc nothrow;
    static nk_rect nk_shrink_rect(nk_rect, float) @nogc nothrow;
    static nk_rect nk_pad_rect(nk_rect, nk_vec2) @nogc nothrow;
    static void nk_unify(nk_rect*, const(nk_rect)*, float, float, float, float) @nogc nothrow;
    static int nk_str_match_star(int, const(char)*, const(char)*) @nogc nothrow;
    static void nk_memset(void*, int, nk_size) @nogc nothrow;
    int nk_strlen(const(char)*) @nogc nothrow;
    int nk_stricmpn(const(char)*, const(char)*, int) @nogc nothrow;
    static int nk_str_match_here(const(char)*, const(char)*) @nogc nothrow;
    int nk_strfilter(const(char)*, const(char)*) @nogc nothrow;
    int nk_strmatch_fuzzy_text(const(char)*, int, const(char)*, int*) @nogc nothrow;
    int nk_strmatch_fuzzy_string(const(char)*, const(char)*, int*) @nogc nothrow;
    static void nk_strrev_ascii(char*) @nogc nothrow;
    static char* nk_itoa(char*, c_long) @nogc nothrow;
    nk_hash nk_murmur_hash(const(void)*, int, nk_hash) @nogc nothrow;


    static char* nk_file_load(const(char)*, nk_size*, nk_allocator*) @nogc nothrow;
    static int nk_parse_hex(const(char)*, int) @nogc nothrow;
    nk_color nk_rgba(int, int, int, int) @nogc nothrow;
    nk_color nk_rgba_hex(const(char)*) @nogc nothrow;


    nk_color nk_rgba_iv(const(int)*) @nogc nothrow;
    nk_color nk_rgb(int, int, int) @nogc nothrow;
    nk_color nk_rgb_iv(const(int)*) @nogc nothrow;
    nk_color nk_rgb_bv(const(nk_byte)*) @nogc nothrow;
    nk_color nk_rgba_u32(nk_uint) @nogc nothrow;
    nk_color nk_rgb_cf(nk_colorf) @nogc nothrow;
    nk_color nk_hsv(int, int, int) @nogc nothrow;
    nk_color nk_hsv_iv(const(int)*) @nogc nothrow;
    nk_color nk_hsv_f(float, float, float) @nogc nothrow;
    nk_color nk_hsv_fv(const(float)*) @nogc nothrow;
    nk_color nk_hsva(int, int, int, int) @nogc nothrow;
    nk_color nk_hsva_iv(const(int)*) @nogc nothrow;
    nk_color nk_hsva_bv(const(nk_byte)*) @nogc nothrow;
    nk_colorf nk_hsva_colorf(float, float, float, float) @nogc nothrow;
    nk_colorf nk_hsva_colorfv(float*) @nogc nothrow;
    nk_color nk_hsva_f(float, float, float, float) @nogc nothrow;
    nk_color nk_hsva_fv(const(float)*) @nogc nothrow;
    void nk_color_fv(float*, nk_color) @nogc nothrow;
    nk_colorf nk_color_cf(nk_color) @nogc nothrow;
    void nk_color_d(double*, double*, double*, double*, nk_color) @nogc nothrow;
    void nk_color_dv(double*, nk_color) @nogc nothrow;
    void nk_color_hsv_fv(float*, nk_color) @nogc nothrow;
    void nk_colorf_hsva_f(float*, float*, float*, float*, nk_colorf) @nogc nothrow;
    void nk_colorf_hsva_fv(float*, nk_colorf) @nogc nothrow;
    void nk_color_hsva_f(float*, float*, float*, float*, nk_color) @nogc nothrow;
    void nk_color_hsva_i(int*, int*, int*, int*, nk_color) @nogc nothrow;
    void nk_color_hsva_iv(int*, nk_color) @nogc nothrow;
    void nk_color_hsva_bv(nk_byte*, nk_color) @nogc nothrow;
    void nk_color_hsv_i(int*, int*, int*, nk_color) @nogc nothrow;
    extern __gshared const(nk_byte)[5] nk_utfbyte;
    extern __gshared const(nk_byte)[5] nk_utfmask;
    extern __gshared const(nk_uint)[5] nk_utfmin;
    extern __gshared const(nk_uint)[5] nk_utfmax;
    static int nk_utf_validate(nk_rune*, int) @nogc nothrow;
    static nk_rune nk_utf_decode_byte(char, int*) @nogc nothrow;
    int nk_utf_decode(const(char)*, nk_rune*, int) @nogc nothrow;
    static char nk_utf_encode_byte(nk_rune, int) @nogc nothrow;
    int nk_utf_encode(nk_rune, char*, int) @nogc nothrow;
    const(char)* nk_utf_at(const(char)*, int, int, nk_rune*, int*) @nogc nothrow;
    static void* nk_malloc(nk_handle, void*, nk_size) @nogc nothrow;
    static void nk_mfree(nk_handle, void*) @nogc nothrow;
    void nk_buffer_init_default(nk_buffer*) @nogc nothrow;
    void nk_buffer_init(nk_buffer*, const(nk_allocator)*, nk_size) @nogc nothrow;
    void nk_buffer_init_fixed(nk_buffer*, void*, nk_size) @nogc nothrow;
    static void* nk_buffer_align(void*, nk_size, nk_size*, nk_buffer_allocation_type) @nogc nothrow;
    static void* nk_buffer_realloc(nk_buffer*, nk_size, nk_size*) @nogc nothrow;
    static void* nk_buffer_alloc(nk_buffer*, nk_buffer_allocation_type, nk_size, nk_size) @nogc nothrow;
    void nk_buffer_push(nk_buffer*, nk_buffer_allocation_type, const(void)*, nk_size, nk_size) @nogc nothrow;
    void nk_buffer_mark(nk_buffer*, nk_buffer_allocation_type) @nogc nothrow;
    void nk_buffer_reset(nk_buffer*, nk_buffer_allocation_type) @nogc nothrow;
    void nk_buffer_clear(nk_buffer*) @nogc nothrow;
    void nk_buffer_free(nk_buffer*) @nogc nothrow;
    void nk_buffer_info(nk_memory_status*, nk_buffer*) @nogc nothrow;
    void* nk_buffer_memory(nk_buffer*) @nogc nothrow;
    void nk_str_init_default(nk_str*) @nogc nothrow;
    void nk_str_init(nk_str*, const(nk_allocator)*, nk_size) @nogc nothrow;
    int nk_str_append_text_char(nk_str*, const(char)*, int) @nogc nothrow;
    int nk_str_append_str_char(nk_str*, const(char)*) @nogc nothrow;
    int nk_str_append_text_utf8(nk_str*, const(char)*, int) @nogc nothrow;
    int nk_str_append_str_utf8(nk_str*, const(char)*) @nogc nothrow;
    int nk_str_append_text_runes(nk_str*, const(nk_rune)*, int) @nogc nothrow;
    int nk_str_append_str_runes(nk_str*, const(nk_rune)*) @nogc nothrow;
    int nk_str_insert_at_char(nk_str*, int, const(char)*, int) @nogc nothrow;
    int nk_str_insert_at_rune(nk_str*, int, const(char)*, int) @nogc nothrow;
    int nk_str_insert_text_char(nk_str*, int, const(char)*, int) @nogc nothrow;
    int nk_str_insert_str_char(nk_str*, int, const(char)*) @nogc nothrow;
    int nk_str_insert_str_runes(nk_str*, int, const(nk_rune)*) @nogc nothrow;
    char* nk_str_at_rune(nk_str*, int, nk_rune*, int*) @nogc nothrow;
    const(char)* nk_str_at_const(const(nk_str)*, int, nk_rune*, int*) @nogc nothrow;
    nk_rune nk_str_rune_at(const(nk_str)*, int) @nogc nothrow;
    const(char)* nk_str_get_const(const(nk_str)*) @nogc nothrow;
    int nk_str_len(nk_str*) @nogc nothrow;
    int nk_str_len_char(nk_str*) @nogc nothrow;
    void nk_str_clear(nk_str*) @nogc nothrow;
    void nk_str_free(nk_str*) @nogc nothrow;
    static void nk_command_buffer_init(nk_command_buffer*, nk_buffer*, nk_command_clipping) @nogc nothrow;
    static void nk_command_buffer_reset(nk_command_buffer*) @nogc nothrow;
    static void* nk_command_buffer_push(nk_command_buffer*, nk_command_type, nk_size) @nogc nothrow;
    void nk_push_scissor(nk_command_buffer*, nk_rect) @nogc nothrow;
    void nk_stroke_line(nk_command_buffer*, float, float, float, float, float, nk_color) @nogc nothrow;
    void nk_stroke_curve(nk_command_buffer*, float, float, float, float, float, float, float, float, float, nk_color) @nogc nothrow;
    void nk_stroke_rect(nk_command_buffer*, nk_rect, float, float, nk_color) @nogc nothrow;
    void nk_fill_rect(nk_command_buffer*, nk_rect, float, nk_color) @nogc nothrow;
    void nk_fill_rect_multi_color(nk_command_buffer*, nk_rect, nk_color, nk_color, nk_color, nk_color) @nogc nothrow;
    void nk_stroke_circle(nk_command_buffer*, nk_rect, float, nk_color) @nogc nothrow;
    void nk_fill_circle(nk_command_buffer*, nk_rect, nk_color) @nogc nothrow;
    void nk_stroke_arc(nk_command_buffer*, float, float, float, float, float, float, nk_color) @nogc nothrow;
    void nk_fill_arc(nk_command_buffer*, float, float, float, float, float, nk_color) @nogc nothrow;
    void nk_stroke_triangle(nk_command_buffer*, float, float, float, float, float, float, float, nk_color) @nogc nothrow;
    void nk_fill_triangle(nk_command_buffer*, float, float, float, float, float, float, nk_color) @nogc nothrow;
    void nk_stroke_polygon(nk_command_buffer*, float*, int, float, nk_color) @nogc nothrow;
    void nk_fill_polygon(nk_command_buffer*, float*, int, nk_color) @nogc nothrow;
    void nk_stroke_polyline(nk_command_buffer*, float*, int, float, nk_color) @nogc nothrow;
    void nk_push_custom(nk_command_buffer*, nk_rect, nk_command_custom_callback, nk_handle) @nogc nothrow;
    void nk_draw_text(nk_command_buffer*, nk_rect, const(char)*, int, const(nk_user_font)*, nk_color, nk_color) @nogc nothrow;
    void nk_draw_list_setup(nk_draw_list*, const(nk_convert_config)*, nk_buffer*, nk_buffer*, nk_buffer*, nk_anti_aliasing, nk_anti_aliasing) @nogc nothrow;
    const(nk_draw_command)* nk__draw_list_begin(const(nk_draw_list)*, const(nk_buffer)*) @nogc nothrow;
    const(nk_draw_command)* nk__draw_list_end(const(nk_draw_list)*, const(nk_buffer)*) @nogc nothrow;
    const(nk_draw_command)* nk__draw_list_next(const(nk_draw_command)*, const(nk_buffer)*, const(nk_draw_list)*) @nogc nothrow;
    static nk_vec2* nk_draw_list_alloc_path(nk_draw_list*, int) @nogc nothrow;
    static nk_vec2 nk_draw_list_path_last(nk_draw_list*) @nogc nothrow;
    static nk_draw_command* nk_draw_list_push_command(nk_draw_list*, nk_rect, nk_handle) @nogc nothrow;
    static nk_draw_command* nk_draw_list_command_last(nk_draw_list*) @nogc nothrow;
    static void nk_draw_list_add_clip(nk_draw_list*, nk_rect) @nogc nothrow;
    static void nk_draw_list_push_image(nk_draw_list*, nk_handle) @nogc nothrow;
    static void* nk_draw_list_alloc_vertices(nk_draw_list*, nk_size) @nogc nothrow;
    static nk_draw_index* nk_draw_list_alloc_elements(nk_draw_list*, nk_size) @nogc nothrow;
    static int nk_draw_vertex_layout_element_is_end_of_layout(const(nk_draw_vertex_layout_element)*) @nogc nothrow;
    static void nk_draw_vertex_color(void*, const(float)*, nk_draw_vertex_layout_format) @nogc nothrow;
    static void nk_draw_vertex_element(void*, const(float)*, int, nk_draw_vertex_layout_format) @nogc nothrow;
    static void* nk_draw_vertex(void*, const(nk_convert_config)*, nk_vec2, nk_vec2, nk_colorf) @nogc nothrow;
    void nk_draw_list_stroke_poly_line(nk_draw_list*, const(nk_vec2)*, const(uint), nk_color, nk_draw_list_stroke, float, nk_anti_aliasing) @nogc nothrow;
    void nk_draw_list_fill_poly_convex(nk_draw_list*, const(nk_vec2)*, const(uint), nk_color, nk_anti_aliasing) @nogc nothrow;
    void nk_draw_list_path_arc_to_fast(nk_draw_list*, nk_vec2, float, int, int) @nogc nothrow;
    void nk_draw_list_path_arc_to(nk_draw_list*, nk_vec2, float, float, float, uint) @nogc nothrow;
    void nk_draw_list_path_stroke(nk_draw_list*, nk_color, nk_draw_list_stroke, float) @nogc nothrow;
    void nk_draw_list_fill_rect(nk_draw_list*, nk_rect, nk_color, float) @nogc nothrow;
    void nk_draw_list_fill_rect_multi_color(nk_draw_list*, nk_rect, nk_color, nk_color, nk_color, nk_color) @nogc nothrow;
    void nk_draw_list_fill_triangle(nk_draw_list*, nk_vec2, nk_vec2, nk_vec2, nk_color) @nogc nothrow;
    void nk_draw_list_fill_circle(nk_draw_list*, nk_vec2, float, nk_color, uint) @nogc nothrow;
    void nk_draw_list_stroke_circle(nk_draw_list*, nk_vec2, float, nk_color, uint, float) @nogc nothrow;
    static void nk_draw_list_push_rect_uv(nk_draw_list*, nk_vec2, nk_vec2, nk_vec2, nk_vec2, nk_color) @nogc nothrow;
    void nk_draw_list_add_image(nk_draw_list*, nk_image, nk_rect, nk_color) @nogc nothrow;
    void nk_draw_list_add_text(nk_draw_list*, const(nk_user_font)*, nk_rect, const(char)*, int, float, nk_color) @nogc nothrow;
    nk_flags nk_convert(nk_context*, nk_buffer*, nk_buffer*, nk_buffer*, const(nk_convert_config)*) @nogc nothrow;
    const(nk_draw_command)* nk__draw_begin(const(nk_context)*, const(nk_buffer)*) @nogc nothrow;
    const(nk_draw_command)* nk__draw_end(const(nk_context)*, const(nk_buffer)*) @nogc nothrow;
    const(nk_draw_command)* nk__draw_next(const(nk_draw_command)*, const(nk_buffer)*, const(nk_context)*) @nogc nothrow;


    alias nk_rp_coord = ushort;
    struct nk_rp_rect
    {
        int id;
        nk_rp_coord w;
        nk_rp_coord h;
        nk_rp_coord x;
        nk_rp_coord y;
        int was_packed;
    }
    struct nk_rp_node
    {
        nk_rp_coord x;
        nk_rp_coord y;
        nk_rp_node* next;
    }
    struct nk_rp_context
    {
        int width;
        int height;
        int align_;
        int init_mode;
        int heuristic;
        int num_nodes;
        nk_rp_node* active_head;
        nk_rp_node* free_head;
        nk_rp_node[2] extra;
    }
    struct nk_rp__findresult
    {
        int x;
        int y;
        nk_rp_node** prev_link;
    }
    enum NK_RP_HEURISTIC
    {
        NK_RP_HEURISTIC_Skyline_default = 0,
        NK_RP_HEURISTIC_Skyline_BL_sortHeight = 0,
        NK_RP_HEURISTIC_Skyline_BF_sortHeight = 1,
    }
    enum NK_RP_HEURISTIC_Skyline_default = NK_RP_HEURISTIC.NK_RP_HEURISTIC_Skyline_default;
    enum NK_RP_HEURISTIC_Skyline_BL_sortHeight = NK_RP_HEURISTIC.NK_RP_HEURISTIC_Skyline_BL_sortHeight;
    enum NK_RP_HEURISTIC_Skyline_BF_sortHeight = NK_RP_HEURISTIC.NK_RP_HEURISTIC_Skyline_BF_sortHeight;
    enum NK_RP_INIT_STATE
    {
        NK_RP__INIT_skyline = 1,
    }
    enum NK_RP__INIT_skyline = NK_RP_INIT_STATE.NK_RP__INIT_skyline;
    static void nk_rp_setup_allow_out_of_mem(nk_rp_context*, int) @nogc nothrow;
    static void nk_rp_init_target(nk_rp_context*, int, int, nk_rp_node*, int) @nogc nothrow;
    static int nk_rp__skyline_find_min_y(nk_rp_context*, nk_rp_node*, int, int, int*) @nogc nothrow;
    static nk_rp__findresult nk_rp__skyline_find_best_pos(nk_rp_context*, int, int) @nogc nothrow;
    static nk_rp__findresult nk_rp__skyline_pack_rectangle(nk_rp_context*, int, int) @nogc nothrow;
    static int nk_rect_height_compare(const(void)*, const(void)*) @nogc nothrow;
    static int nk_rect_original_order(const(void)*, const(void)*) @nogc nothrow;
    static void nk_rp_qsort(nk_rp_rect*, uint, int function(const(void)*, const(void)*)) @nogc nothrow;


    static void nk_rp_pack_rects(nk_rp_context*, nk_rp_rect*, int) @nogc nothrow;




    struct nk_tt_bakedchar
    {
        ushort x0;
        ushort y0;
        ushort x1;
        ushort y1;
        float xoff;
        float yoff;
        float xadvance;
    }
    struct nk_tt_aligned_quad
    {
        float x0;
        float y0;
        float s0;
        float t0;
        float x1;
        float y1;
        float s1;
        float t1;
    }
    struct nk_tt_packedchar
    {
        ushort x0;
        ushort y0;
        ushort x1;
        ushort y1;
        float xoff;
        float yoff;
        float xadvance;
        float xoff2;
        float yoff2;
    }
    struct nk_tt_pack_range
    {
        float font_size;
        int first_unicode_codepoint_in_range;
        int* array_of_unicode_codepoints;
        int num_chars;
        nk_tt_packedchar* chardata_for_range;
        ubyte h_oversample;
        ubyte v_oversample;
    }
    struct nk_tt_pack_context
    {
        void* pack_info;
        int width;
        int height;
        int stride_in_bytes;
        int padding;
        uint h_oversample;
        uint v_oversample;
        ubyte* pixels;
        void* nodes;
    }
    struct nk_tt_fontinfo
    {
        const(ubyte)* data;
        int fontstart;
        int numGlyphs;
        int loca;
        int head;
        int glyf;
        int hhea;
        int hmtx;
        int kern;
        int index_map;
        int indexToLocFormat;
    }
    struct nk_tt_vertex
    {
        short x;
        short y;
        short cx;
        short cy;
        ubyte type;
        ubyte padding;
    }
    struct nk_tt__bitmap
    {
        int w;
        int h;
        int stride;
        ubyte* pixels;
    }
    struct nk_tt__hheap_chunk
    {
        nk_tt__hheap_chunk* next;
    }
    struct nk_tt__hheap
    {
        nk_allocator alloc;
        nk_tt__hheap_chunk* head;
        void* first_free;
        int num_remaining_in_head_chunk;
    }
    struct nk_tt__edge
    {
        float x0;
        float y0;
        float x1;
        float y1;
        int invert;
    }
    struct nk_tt__active_edge
    {
        nk_tt__active_edge* next;
        float fx;
        float fdx;
        float fdy;
        float direction;
        float sy;
        float ey;
    }
    struct nk_tt__point
    {
        float x;
        float y;
    }
    static nk_ushort nk_ttUSHORT(const(nk_byte)*) @nogc nothrow;
    static nk_short nk_ttSHORT(const(nk_byte)*) @nogc nothrow;
    static nk_uint nk_ttULONG(const(nk_byte)*) @nogc nothrow;





    static nk_uint nk_tt__find_table(const(nk_byte)*, nk_uint, const(char)*) @nogc nothrow;
    static int nk_tt_InitFont(nk_tt_fontinfo*, const(ubyte)*, int) @nogc nothrow;
    static int nk_tt_FindGlyphIndex(const(nk_tt_fontinfo)*, int) @nogc nothrow;
    static void nk_tt_setvertex(nk_tt_vertex*, nk_byte, nk_int, nk_int, nk_int, nk_int) @nogc nothrow;
    static int nk_tt__GetGlyfOffset(const(nk_tt_fontinfo)*, int) @nogc nothrow;
    static int nk_tt_GetGlyphBox(const(nk_tt_fontinfo)*, int, int*, int*, int*, int*) @nogc nothrow;
    static int nk_tt__close_shape(nk_tt_vertex*, int, int, int, nk_int, nk_int, nk_int, nk_int, nk_int, nk_int) @nogc nothrow;
    static int nk_tt_GetGlyphShape(const(nk_tt_fontinfo)*, nk_allocator*, int, nk_tt_vertex**) @nogc nothrow;
    static void nk_tt_GetGlyphHMetrics(const(nk_tt_fontinfo)*, int, int*, int*) @nogc nothrow;
    static void nk_tt_GetFontVMetrics(const(nk_tt_fontinfo)*, int*, int*, int*) @nogc nothrow;
    static float nk_tt_ScaleForPixelHeight(const(nk_tt_fontinfo)*, float) @nogc nothrow;
    static float nk_tt_ScaleForMappingEmToPixels(const(nk_tt_fontinfo)*, float) @nogc nothrow;
    static void nk_tt_GetGlyphBitmapBoxSubpixel(const(nk_tt_fontinfo)*, int, float, float, float, float, int*, int*, int*, int*) @nogc nothrow;
    static void nk_tt_GetGlyphBitmapBox(const(nk_tt_fontinfo)*, int, float, float, int*, int*, int*, int*) @nogc nothrow;
    static void* nk_tt__hheap_alloc(nk_tt__hheap*, nk_size) @nogc nothrow;
    static void nk_tt__hheap_free(nk_tt__hheap*, void*) @nogc nothrow;
    static void nk_tt__hheap_cleanup(nk_tt__hheap*) @nogc nothrow;
    static nk_tt__active_edge* nk_tt__new_active(nk_tt__hheap*, nk_tt__edge*, int, float) @nogc nothrow;
    static void nk_tt__handle_clipped_edge(float*, int, nk_tt__active_edge*, float, float, float, float) @nogc nothrow;
    static void nk_tt__fill_active_edges_new(float*, float*, int, nk_tt__active_edge*, float) @nogc nothrow;
    static void nk_tt__rasterize_sorted_edges(nk_tt__bitmap*, nk_tt__edge*, int, int, int, int, nk_allocator*) @nogc nothrow;
    static void nk_tt__sort_edges_ins_sort(nk_tt__edge*, int) @nogc nothrow;


    static void nk_tt__sort_edges_quicksort(nk_tt__edge*, int) @nogc nothrow;
    static void nk_tt__sort_edges(nk_tt__edge*, int) @nogc nothrow;
    static void nk_tt__rasterize(nk_tt__bitmap*, nk_tt__point*, int*, int, float, float, float, float, int, int, int, nk_allocator*) @nogc nothrow;
    static void nk_tt__add_point(nk_tt__point*, int, float, float) @nogc nothrow;
    static int nk_tt__tesselate_curve(nk_tt__point*, int*, float, float, float, float, float, float, float, int) @nogc nothrow;
    static nk_tt__point* nk_tt_FlattenCurves(nk_tt_vertex*, int, float, int**, int*, nk_allocator*) @nogc nothrow;
    static void nk_tt_Rasterize(nk_tt__bitmap*, float, nk_tt_vertex*, int, float, float, float, float, int, int, int, nk_allocator*) @nogc nothrow;
    static void nk_tt_MakeGlyphBitmapSubpixel(const(nk_tt_fontinfo)*, ubyte*, int, int, int, float, float, float, float, int, nk_allocator*) @nogc nothrow;
    static int nk_tt_PackBegin(nk_tt_pack_context*, ubyte*, int, int, int, int, nk_allocator*) @nogc nothrow;
    static void nk_tt_PackEnd(nk_tt_pack_context*, nk_allocator*) @nogc nothrow;
    static void nk_tt_PackSetOversampling(nk_tt_pack_context*, uint, uint) @nogc nothrow;
    static void nk_tt__h_prefilter(ubyte*, int, int, int, int) @nogc nothrow;
    static void nk_tt__v_prefilter(ubyte*, int, int, int, int) @nogc nothrow;
    static float nk_tt__oversample_shift(int) @nogc nothrow;
    static int nk_tt_PackFontRangesGatherRects(nk_tt_pack_context*, nk_tt_fontinfo*, nk_tt_pack_range*, int, nk_rp_rect*) @nogc nothrow;
    static int nk_tt_PackFontRangesRenderIntoRects(nk_tt_pack_context*, nk_tt_fontinfo*, nk_tt_pack_range*, int, nk_rp_rect*, nk_allocator*) @nogc nothrow;
    static void nk_tt_GetPackedQuad(nk_tt_packedchar*, int, int, int, float*, float*, nk_tt_aligned_quad*, int) @nogc nothrow;
    struct nk_font_bake_data
    {
        nk_tt_fontinfo info;
        nk_rp_rect* rects;
        nk_tt_pack_range* ranges;
        nk_rune range_count;
    }
    struct nk_font_baker
    {
        nk_allocator alloc;
        nk_tt_pack_context spc;
        nk_font_bake_data* build;
        nk_tt_packedchar* packed_chars;
        nk_rp_rect* rects;
        nk_tt_pack_range* ranges;
    }
    extern __gshared const(nk_size) nk_rect_align;
    extern __gshared const(nk_size) nk_range_align;
    extern __gshared const(nk_size) nk_char_align;
    extern __gshared const(nk_size) nk_build_align;
    extern __gshared const(nk_size) nk_baker_align;
    static int nk_range_count(const(nk_rune)*) @nogc nothrow;
    static int nk_range_glyph_count(const(nk_rune)*, int) @nogc nothrow;
    const(nk_rune)* nk_font_chinese_glyph_ranges() @nogc nothrow;
    const(nk_rune)* nk_font_cyrillic_glyph_ranges() @nogc nothrow;
    const(nk_rune)* nk_font_korean_glyph_ranges() @nogc nothrow;
    static void nk_font_baker_memory(nk_size*, int*, nk_font_config*, int) @nogc nothrow;
    pragma(mangle, "nk_font_baker") static nk_font_baker* nk_font_baker_(void*, int, int, nk_allocator*) @nogc nothrow;
    static int nk_font_bake_pack(nk_font_baker*, nk_size*, int*, int*, nk_recti*, const(nk_font_config)*, int, nk_allocator*) @nogc nothrow;
    static void nk_font_bake(nk_font_baker*, void*, int, int, nk_font_glyph*, int, const(nk_font_config)*, int) @nogc nothrow;
    static void nk_font_bake_custom_data(void*, int, int, nk_recti, const(char)*, int, int, char, char) @nogc nothrow;
    static void nk_font_bake_convert(void*, int, int, const(void)*) @nogc nothrow;
    static float nk_font_text_width(nk_handle, float, const(char)*, int) @nogc nothrow;
    static void nk_font_query_font_glyph(nk_handle, float, nk_user_font_glyph*, nk_rune, nk_rune) @nogc nothrow;
    const(nk_font_glyph)* nk_font_find_glyph(nk_font*, nk_rune) @nogc nothrow;
    static void nk_font_init(nk_font*, float, nk_rune, nk_font_glyph*, const(nk_baked_font)*, nk_handle) @nogc nothrow;
    extern __gshared const(char)[11981] nk_proggy_clean_ttf_compressed_data_base85;




    extern __gshared const(char)[2431] nk_custom_cursor_data;
    extern __gshared ubyte* nk__barrier;
    extern __gshared ubyte* nk__barrier2;
    extern __gshared ubyte* nk__barrier3;
    extern __gshared ubyte* nk__barrier4;
    extern __gshared ubyte* nk__dout;
    static uint nk_decompress_length(ubyte*) @nogc nothrow;
    static void nk__match(ubyte*, uint) @nogc nothrow;
    static void nk__lit(ubyte*, uint) @nogc nothrow;
    static ubyte* nk_decompress_token(ubyte*) @nogc nothrow;






    static uint nk_adler32(uint, ubyte*, uint) @nogc nothrow;
    static uint nk_decompress(ubyte*, ubyte*, uint) @nogc nothrow;
    static uint nk_decode_85_byte(char) @nogc nothrow;
    static void nk_decode_85(ubyte*, const(ubyte)*) @nogc nothrow;
    void nk_font_atlas_init_default(nk_font_atlas*) @nogc nothrow;
    void nk_font_atlas_init(nk_font_atlas*, nk_allocator*) @nogc nothrow;
    void nk_font_atlas_init_custom(nk_font_atlas*, nk_allocator*, nk_allocator*) @nogc nothrow;
    void nk_font_atlas_begin(nk_font_atlas*) @nogc nothrow;
    void nk_font_atlas_end(nk_font_atlas*, nk_handle, nk_draw_null_texture*) @nogc nothrow;
    void nk_font_atlas_cleanup(nk_font_atlas*) @nogc nothrow;
    void nk_font_atlas_clear(nk_font_atlas*) @nogc nothrow;
    void nk_input_begin(nk_context*) @nogc nothrow;
    void nk_input_end(nk_context*) @nogc nothrow;
    void nk_input_motion(nk_context*, int, int) @nogc nothrow;
    void nk_input_key(nk_context*, nk_keys, int) @nogc nothrow;
    void nk_input_scroll(nk_context*, nk_vec2) @nogc nothrow;
    void nk_input_glyph(nk_context*, const(nk_glyph)) @nogc nothrow;
    void nk_input_char(nk_context*, char) @nogc nothrow;
    void nk_input_unicode(nk_context*, nk_rune) @nogc nothrow;
    int nk_input_has_mouse_click(const(nk_input)*, nk_buttons) @nogc nothrow;
    int nk_input_has_mouse_click_down_in_rect(const(nk_input)*, nk_buttons, nk_rect, int) @nogc nothrow;
    int nk_input_is_mouse_click_in_rect(const(nk_input)*, nk_buttons, nk_rect) @nogc nothrow;
    int nk_input_any_mouse_click_in_rect(const(nk_input)*, nk_rect) @nogc nothrow;
    int nk_input_is_mouse_hovering_rect(const(nk_input)*, nk_rect) @nogc nothrow;
    int nk_input_is_mouse_prev_hovering_rect(const(nk_input)*, nk_rect) @nogc nothrow;
    int nk_input_mouse_clicked(const(nk_input)*, nk_buttons, nk_rect) @nogc nothrow;
    int nk_input_is_mouse_down(const(nk_input)*, nk_buttons) @nogc nothrow;
    int nk_input_is_mouse_pressed(const(nk_input)*, nk_buttons) @nogc nothrow;
    int nk_input_is_key_released(const(nk_input)*, nk_keys) @nogc nothrow;
    void nk_style_default(nk_context*) @nogc nothrow;
    extern __gshared const(nk_color)[28] nk_default_color_style;


    extern __gshared const(char)*[28] nk_color_names;
    const(char)* nk_style_get_color_by_name(nk_style_colors) @nogc nothrow;
    nk_style_item nk_style_item_color(nk_color) @nogc nothrow;
    nk_style_item nk_style_item_hide() @nogc nothrow;
    void nk_style_set_font(nk_context*, const(nk_user_font)*) @nogc nothrow;
    int nk_style_push_flags(nk_context*, nk_flags*, nk_flags) @nogc nothrow;
    int nk_style_push_color(nk_context*, nk_color*, nk_color) @nogc nothrow;
    int nk_style_pop_style_item(nk_context*) @nogc nothrow;
    int nk_style_pop_float(nk_context*) @nogc nothrow;
    int nk_style_pop_vec2(nk_context*) @nogc nothrow;
    void nk_style_hide_cursor(nk_context*) @nogc nothrow;
    void nk_style_load_cursor(nk_context*, nk_style_cursor, const(nk_cursor)*) @nogc nothrow;
    void nk_style_load_all_cursors(nk_context*, nk_cursor*) @nogc nothrow;
    static void nk_setup(nk_context*, const(nk_user_font)*) @nogc nothrow;
    int nk_init_fixed(nk_context*, void*, nk_size, const(nk_user_font)*) @nogc nothrow;
    static void nk_start_buffer(nk_context*, nk_command_buffer*) @nogc nothrow;
    static void nk_start_popup(nk_context*, nk_window*) @nogc nothrow;
    static void nk_finish_popup(nk_context*, nk_window*) @nogc nothrow;
    static void nk_finish(nk_context*, nk_window*) @nogc nothrow;
    static void nk_pool_init(nk_pool*, nk_allocator*, uint) @nogc nothrow;
    static void nk_pool_free(nk_pool*) @nogc nothrow;
    static void nk_pool_init_fixed(nk_pool*, void*, nk_size) @nogc nothrow;
    static nk_page_element* nk_create_page_element(nk_context*) @nogc nothrow;
    static void nk_free_page_element(nk_context*, nk_page_element*) @nogc nothrow;
    static nk_uint* nk_find_value(nk_window*, nk_hash) @nogc nothrow;
    static void* nk_create_panel(nk_context*) @nogc nothrow;
    static void nk_free_panel(nk_context*, nk_panel*) @nogc nothrow;
    static int nk_panel_has_header(nk_flags, const(char)*) @nogc nothrow;
    static nk_vec2 nk_panel_get_padding(const(nk_style)*, nk_panel_type) @nogc nothrow;
    static float nk_panel_get_border(const(nk_style)*, nk_flags, nk_panel_type) @nogc nothrow;
    static nk_color nk_panel_get_border_color(const(nk_style)*, nk_panel_type) @nogc nothrow;
    static int nk_panel_is_sub(nk_panel_type) @nogc nothrow;
    static int nk_panel_begin(nk_context*, const(char)*, nk_panel_type) @nogc nothrow;
    static void nk_panel_end(nk_context*) @nogc nothrow;
    static void* nk_create_window(nk_context*) @nogc nothrow;
    static void nk_free_window(nk_context*, nk_window*) @nogc nothrow;
    static nk_window* nk_find_window(nk_context*, nk_hash, const(char)*) @nogc nothrow;
    static void nk_insert_window(nk_context*, nk_window*, nk_window_insert_location) @nogc nothrow;
    int nk_begin_titled(nk_context*, const(char)*, const(char)*, nk_rect, nk_flags) @nogc nothrow;
    void nk_end(nk_context*) @nogc nothrow;
    nk_vec2 nk_window_get_position(const(nk_context)*) @nogc nothrow;
    float nk_window_get_width(const(nk_context)*) @nogc nothrow;
    nk_rect nk_window_get_content_region(nk_context*) @nogc nothrow;
    nk_vec2 nk_window_get_content_region_min(nk_context*) @nogc nothrow;
    nk_vec2 nk_window_get_content_region_max(nk_context*) @nogc nothrow;
    nk_vec2 nk_window_get_content_region_size(nk_context*) @nogc nothrow;
    nk_command_buffer* nk_window_get_canvas(nk_context*) @nogc nothrow;
    nk_panel* nk_window_get_panel(nk_context*) @nogc nothrow;
    int nk_window_is_hovered(nk_context*) @nogc nothrow;
    int nk_window_is_collapsed(nk_context*, const(char)*) @nogc nothrow;
    int nk_window_is_closed(nk_context*, const(char)*) @nogc nothrow;
    int nk_window_is_hidden(nk_context*, const(char)*) @nogc nothrow;
    int nk_window_is_active(nk_context*, const(char)*) @nogc nothrow;
    nk_window* nk_window_find(nk_context*, const(char)*) @nogc nothrow;
    void nk_window_close(nk_context*, const(char)*) @nogc nothrow;
    void nk_window_set_bounds(nk_context*, const(char)*, nk_rect) @nogc nothrow;
    void nk_window_set_position(nk_context*, const(char)*, nk_vec2) @nogc nothrow;
    void nk_window_collapse(nk_context*, const(char)*, nk_collapse_states) @nogc nothrow;
    void nk_window_collapse_if(nk_context*, const(char)*, nk_collapse_states, int) @nogc nothrow;
    void nk_window_show(nk_context*, const(char)*, nk_show_states) @nogc nothrow;
    void nk_window_show_if(nk_context*, const(char)*, nk_show_states, int) @nogc nothrow;
    void nk_window_set_focus(nk_context*, const(char)*) @nogc nothrow;
    static int nk_nonblock_begin(nk_context*, nk_flags, nk_rect, nk_rect, nk_panel_type) @nogc nothrow;
    void nk_popup_close(nk_context*) @nogc nothrow;
    void nk_popup_end(nk_context*) @nogc nothrow;
    int nk_contextual_begin(nk_context*, nk_flags, nk_vec2, nk_rect) @nogc nothrow;
    int nk_contextual_item_text(nk_context*, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_contextual_item_label(nk_context*, const(char)*, nk_flags) @nogc nothrow;
    int nk_contextual_item_image_text(nk_context*, nk_image, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_contextual_item_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_contextual_item_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags) @nogc nothrow;
    void nk_contextual_close(nk_context*) @nogc nothrow;
    void nk_contextual_end(nk_context*) @nogc nothrow;
    void nk_menubar_begin(nk_context*) @nogc nothrow;
    static int nk_menu_begin(nk_context*, nk_window*, const(char)*, int, nk_rect, nk_vec2) @nogc nothrow;
    int nk_menu_begin_label(nk_context*, const(char)*, nk_flags, nk_vec2) @nogc nothrow;
    int nk_menu_item_label(nk_context*, const(char)*, nk_flags) @nogc nothrow;
    int nk_menu_item_image_label(nk_context*, nk_image, const(char)*, nk_flags) @nogc nothrow;
    int nk_menu_item_image_text(nk_context*, nk_image, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_menu_item_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_menu_item_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags) @nogc nothrow;
    void nk_menu_end(nk_context*) @nogc nothrow;
    void nk_layout_set_min_row_height(nk_context*, float) @nogc nothrow;
    static float nk_layout_row_calculate_usable_space(const(nk_style)*, nk_panel_type, float, int) @nogc nothrow;
    static void nk_panel_layout(const(nk_context)*, nk_window*, float, int) @nogc nothrow;
    pragma(mangle, "nk_row_layout") static void nk_row_layout_(nk_context*, nk_layout_format, float, int, int) @nogc nothrow;
    float nk_layout_ratio_from_pixel(nk_context*, float) @nogc nothrow;
    void nk_layout_row_dynamic(nk_context*, float, int) @nogc nothrow;
    void nk_layout_row_static(nk_context*, float, int, int) @nogc nothrow;
    void nk_layout_row_template_begin(nk_context*, float) @nogc nothrow;
    void nk_layout_row_template_push_variable(nk_context*, float) @nogc nothrow;
    void nk_layout_space_begin(nk_context*, nk_layout_format, float, int) @nogc nothrow;
    void nk_layout_space_end(nk_context*) @nogc nothrow;
    void nk_layout_space_push(nk_context*, nk_rect) @nogc nothrow;
    nk_rect nk_layout_widget_bounds(nk_context*) @nogc nothrow;
    nk_vec2 nk_layout_space_to_screen(nk_context*, nk_vec2) @nogc nothrow;
    nk_vec2 nk_layout_space_to_local(nk_context*, nk_vec2) @nogc nothrow;
    nk_rect nk_layout_space_rect_to_screen(nk_context*, nk_rect) @nogc nothrow;
    static void nk_panel_alloc_row(const(nk_context)*, nk_window*) @nogc nothrow;
    static void nk_layout_widget_space(nk_rect*, const(nk_context)*, nk_window*, int) @nogc nothrow;
    static int nk_tree_state_base(nk_context*, nk_tree_type, nk_image*, const(char)*, nk_collapse_states*) @nogc nothrow;
    static int nk_tree_base(nk_context*, nk_tree_type, nk_image*, const(char)*, nk_collapse_states, const(char)*, int, int) @nogc nothrow;
    int nk_tree_state_push(nk_context*, nk_tree_type, const(char)*, nk_collapse_states*) @nogc nothrow;
    void nk_tree_state_pop(nk_context*) @nogc nothrow;
    int nk_tree_push_hashed(nk_context*, nk_tree_type, const(char)*, nk_collapse_states, const(char)*, int, int) @nogc nothrow;
    int nk_tree_image_push_hashed(nk_context*, nk_tree_type, nk_image, const(char)*, nk_collapse_states, const(char)*, int, int) @nogc nothrow;
    void nk_tree_pop(nk_context*) @nogc nothrow;
    static int nk_tree_element_image_push_hashed_base(nk_context*, nk_tree_type, nk_image*, const(char)*, int, nk_collapse_states*, int*) @nogc nothrow;
    static int nk_tree_element_base(nk_context*, nk_tree_type, nk_image*, const(char)*, nk_collapse_states, int*, const(char)*, int, int) @nogc nothrow;
    int nk_tree_element_push_hashed(nk_context*, nk_tree_type, const(char)*, nk_collapse_states, int*, const(char)*, int, int) @nogc nothrow;
    int nk_tree_element_image_push_hashed(nk_context*, nk_tree_type, nk_image, const(char)*, nk_collapse_states, int*, const(char)*, int, int) @nogc nothrow;
    void nk_tree_element_pop(nk_context*) @nogc nothrow;
    int nk_group_scrolled_offset_begin(nk_context*, nk_uint*, nk_uint*, const(char)*, nk_flags) @nogc nothrow;
    void nk_group_scrolled_end(nk_context*) @nogc nothrow;
    int nk_group_scrolled_begin(nk_context*, nk_scroll*, const(char)*, nk_flags) @nogc nothrow;
    int nk_group_begin_titled(nk_context*, const(char)*, const(char)*, nk_flags) @nogc nothrow;
    int nk_group_begin(nk_context*, const(char)*, nk_flags) @nogc nothrow;
    void nk_group_end(nk_context*) @nogc nothrow;
    int nk_list_view_begin(nk_context*, nk_list_view*, const(char)*, nk_flags, int, int) @nogc nothrow;
    void nk_list_view_end(nk_list_view*) @nogc nothrow;
    nk_rect nk_widget_bounds(nk_context*) @nogc nothrow;
    nk_vec2 nk_widget_position(nk_context*) @nogc nothrow;
    nk_vec2 nk_widget_size(nk_context*) @nogc nothrow;
    float nk_widget_width(nk_context*) @nogc nothrow;
    float nk_widget_height(nk_context*) @nogc nothrow;
    int nk_widget_is_mouse_clicked(nk_context*, nk_buttons) @nogc nothrow;
    int nk_widget_has_mouse_click_down(nk_context*, nk_buttons, int) @nogc nothrow;
    nk_widget_layout_states nk_widget(nk_rect*, const(nk_context)*) @nogc nothrow;
    nk_widget_layout_states nk_widget_fitting(nk_rect*, nk_context*, nk_vec2) @nogc nothrow;
    void nk_spacing(nk_context*, int) @nogc nothrow;
    static void nk_widget_text(nk_command_buffer*, nk_rect, const(char)*, int, const(nk_text)*, nk_flags, const(nk_user_font)*) @nogc nothrow;
    void nk_labelf(nk_context*, nk_flags, const(char)*, ...) @nogc nothrow;
    void nk_labelf_wrap(nk_context*, const(char)*, ...) @nogc nothrow;
    void nk_value_bool(nk_context*, const(char)*, int) @nogc nothrow;
    void nk_value_int(nk_context*, const(char)*, int) @nogc nothrow;
    void nk_value_uint(nk_context*, const(char)*, uint) @nogc nothrow;
    void nk_value_float(nk_context*, const(char)*, float) @nogc nothrow;
    void nk_value_color_byte(nk_context*, const(char)*, nk_color) @nogc nothrow;
    void nk_value_color_float(nk_context*, const(char)*, nk_color) @nogc nothrow;
    void nk_value_color_hex(nk_context*, const(char)*, nk_color) @nogc nothrow;
    pragma(mangle, "nk_text") void nk_text_(nk_context*, const(char)*, int, nk_flags) @nogc nothrow;
    void nk_text_wrap(nk_context*, const(char)*, int) @nogc nothrow;
    void nk_label(nk_context*, const(char)*, nk_flags) @nogc nothrow;
    void nk_label_colored(nk_context*, const(char)*, nk_flags, nk_color) @nogc nothrow;
    void nk_label_wrap(nk_context*, const(char)*) @nogc nothrow;
    void nk_label_colored_wrap(nk_context*, const(char)*, nk_color) @nogc nothrow;
    nk_handle nk_handle_ptr(void*) @nogc nothrow;
    nk_image nk_subimage_ptr(void*, ushort, ushort, nk_rect) @nogc nothrow;
    nk_image nk_subimage_id(int, ushort, ushort, nk_rect) @nogc nothrow;
    nk_image nk_subimage_handle(nk_handle, ushort, ushort, nk_rect) @nogc nothrow;
    nk_image nk_image_handle(nk_handle) @nogc nothrow;
    nk_image nk_image_ptr(void*) @nogc nothrow;
    pragma(mangle, "nk_image") void nk_image_(nk_context*, nk_image) @nogc nothrow;
    void nk_image_color(nk_context*, nk_image, nk_color) @nogc nothrow;
    static void nk_draw_symbol(nk_command_buffer*, nk_symbol_type, nk_rect, nk_color, nk_color, float, const(nk_user_font)*) @nogc nothrow;
    pragma(mangle, "nk_button_behavior") static int nk_button_behavior_(nk_flags*, nk_rect, const(nk_input)*, nk_button_behavior) @nogc nothrow;
    static int nk_do_button_symbol(nk_flags*, nk_command_buffer*, nk_rect, nk_symbol_type, nk_button_behavior, const(nk_style_button)*, const(nk_input)*, const(nk_user_font)*) @nogc nothrow;
    static int nk_do_button_image(nk_flags*, nk_command_buffer*, nk_rect, nk_image, nk_button_behavior, const(nk_style_button)*, const(nk_input)*) @nogc nothrow;
    static void nk_draw_button_text_symbol(nk_command_buffer*, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, nk_flags, const(nk_style_button)*, const(char)*, int, nk_symbol_type, const(nk_user_font)*) @nogc nothrow;
    void nk_button_set_behavior(nk_context*, nk_button_behavior) @nogc nothrow;
    int nk_button_pop_behavior(nk_context*) @nogc nothrow;
    int nk_button_text(nk_context*, const(char)*, int) @nogc nothrow;
    int nk_button_label_styled(nk_context*, const(nk_style_button)*, const(char)*) @nogc nothrow;
    int nk_button_label(nk_context*, const(char)*) @nogc nothrow;
    int nk_button_color(nk_context*, nk_color) @nogc nothrow;
    int nk_button_symbol_styled(nk_context*, const(nk_style_button)*, nk_symbol_type) @nogc nothrow;
    int nk_button_image_styled(nk_context*, const(nk_style_button)*, nk_image) @nogc nothrow;
    int nk_button_image(nk_context*, nk_image) @nogc nothrow;
    int nk_button_symbol_text_styled(nk_context*, const(nk_style_button)*, nk_symbol_type, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_button_symbol_label_styled(nk_context*, const(nk_style_button)*, nk_symbol_type, const(char)*, nk_flags) @nogc nothrow;
    int nk_button_image_text_styled(nk_context*, const(nk_style_button)*, nk_image, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_button_image_text(nk_context*, nk_image, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_button_image_label_styled(nk_context*, const(nk_style_button)*, nk_image, const(char)*, nk_flags) @nogc nothrow;
    static int nk_toggle_behavior(const(nk_input)*, nk_rect, nk_flags*, int) @nogc nothrow;
    static void nk_draw_checkbox(nk_command_buffer*, nk_flags, const(nk_style_toggle)*, int, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, const(char)*, int, const(nk_user_font)*) @nogc nothrow;
    static void nk_draw_option(nk_command_buffer*, nk_flags, const(nk_style_toggle)*, int, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, const(char)*, int, const(nk_user_font)*) @nogc nothrow;
    static int nk_do_toggle(nk_flags*, nk_command_buffer*, nk_rect, int*, const(char)*, int, nk_toggle_type, const(nk_style_toggle)*, const(nk_input)*, const(nk_user_font)*) @nogc nothrow;
    int nk_check_text(nk_context*, const(char)*, int, int) @nogc nothrow;
    uint nk_check_flags_text(nk_context*, const(char)*, int, uint, uint) @nogc nothrow;
    int nk_checkbox_text(nk_context*, const(char)*, int, int*) @nogc nothrow;
    uint nk_check_flags_label(nk_context*, const(char)*, uint, uint) @nogc nothrow;
    int nk_radio_text(nk_context*, const(char)*, int, int*) @nogc nothrow;
    int nk_option_label(nk_context*, const(char)*, int) @nogc nothrow;
    int nk_radio_label(nk_context*, const(char)*, int*) @nogc nothrow;
    static int nk_do_selectable(nk_flags*, nk_command_buffer*, nk_rect, const(char)*, int, nk_flags, int*, const(nk_style_selectable)*, const(nk_input)*, const(nk_user_font)*) @nogc nothrow;
    static int nk_do_selectable_image(nk_flags*, nk_command_buffer*, nk_rect, const(char)*, int, nk_flags, int*, const(nk_image)*, const(nk_style_selectable)*, const(nk_input)*, const(nk_user_font)*) @nogc nothrow;
    static int nk_do_selectable_symbol(nk_flags*, nk_command_buffer*, nk_rect, const(char)*, int, nk_flags, int*, nk_symbol_type, const(nk_style_selectable)*, const(nk_input)*, const(nk_user_font)*) @nogc nothrow;
    int nk_selectable_text(nk_context*, const(char)*, int, nk_flags, int*) @nogc nothrow;
    int nk_selectable_image_text(nk_context*, nk_image, const(char)*, int, nk_flags, int*) @nogc nothrow;
    int nk_selectable_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags, int*) @nogc nothrow;
    int nk_selectable_image_label(nk_context*, nk_image, const(char)*, nk_flags, int*) @nogc nothrow;
    int nk_select_image_label(nk_context*, nk_image, const(char)*, nk_flags, int) @nogc nothrow;
    int nk_select_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags, int) @nogc nothrow;
    int nk_select_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags, int) @nogc nothrow;
    static void nk_draw_slider(nk_command_buffer*, nk_flags, const(nk_style_slider)*, const(nk_rect)*, const(nk_rect)*, float, float, float) @nogc nothrow;
    int nk_slider_float(nk_context*, float, float*, float, float) @nogc nothrow;
    float nk_slide_float(nk_context*, float, float, float, float) @nogc nothrow;
    int nk_slide_int(nk_context*, int, int, int, int) @nogc nothrow;
    static void nk_draw_progress(nk_command_buffer*, nk_flags, const(nk_style_progress)*, const(nk_rect)*, const(nk_rect)*, nk_size, nk_size) @nogc nothrow;
    static nk_size nk_do_progress(nk_flags*, nk_command_buffer*, nk_rect, nk_size, nk_size, int, const(nk_style_progress)*, nk_input*) @nogc nothrow;
    int nk_progress(nk_context*, nk_size*, nk_size, int) @nogc nothrow;
    static float nk_scrollbar_behavior(nk_flags*, nk_input*, int, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, float, float, float, nk_orientation) @nogc nothrow;
    static void nk_draw_scrollbar(nk_command_buffer*, nk_flags, const(nk_style_scrollbar)*, const(nk_rect)*, const(nk_rect)*) @nogc nothrow;
    static float nk_do_scrollbarv(nk_flags*, nk_command_buffer*, nk_rect, int, float, float, float, float, const(nk_style_scrollbar)*, nk_input*, const(nk_user_font)*) @nogc nothrow;
    static float nk_do_scrollbarh(nk_flags*, nk_command_buffer*, nk_rect, int, float, float, float, float, const(nk_style_scrollbar)*, nk_input*, const(nk_user_font)*) @nogc nothrow;
    struct nk_text_find
    {
        float x;
        float y;
        float height;
        int first_char;
        int length;
        int prev_first;
    }
    struct nk_text_edit_row
    {
        float x0;
        float x1;
        float baseline_y_delta;
        float ymin;
        float ymax;
        int num_chars;
    }


    static float nk_textedit_get_width(const(nk_text_edit)*, int, int, const(nk_user_font)*) @nogc nothrow;
    static void nk_textedit_layout_row(nk_text_edit_row*, nk_text_edit*, int, float, const(nk_user_font)*) @nogc nothrow;
    static int nk_textedit_locate_coord(nk_text_edit*, float, float, const(nk_user_font)*, float) @nogc nothrow;
    static void nk_textedit_click(nk_text_edit*, float, float, const(nk_user_font)*, float) @nogc nothrow;
    static void nk_textedit_find_charpos(nk_text_find*, nk_text_edit*, int, int, const(nk_user_font)*, float) @nogc nothrow;
    static void nk_textedit_clamp(nk_text_edit*) @nogc nothrow;
    void nk_textedit_delete_selection(nk_text_edit*) @nogc nothrow;
    static void nk_textedit_sortselection(nk_text_edit*) @nogc nothrow;
    static void nk_textedit_move_to_first(nk_text_edit*) @nogc nothrow;
    static void nk_textedit_move_to_last(nk_text_edit*) @nogc nothrow;
    static int nk_is_word_boundary(nk_text_edit*, int) @nogc nothrow;
    static int nk_textedit_move_to_word_previous(nk_text_edit*) @nogc nothrow;
    static int nk_textedit_move_to_word_next(nk_text_edit*) @nogc nothrow;
    static void nk_textedit_prep_selection_at_cursor(nk_text_edit*) @nogc nothrow;
    int nk_textedit_cut(nk_text_edit*) @nogc nothrow;
    void nk_textedit_text(nk_text_edit*, const(char)*, int) @nogc nothrow;
    static void nk_textedit_flush_redo(nk_text_undo_state*) @nogc nothrow;
    static void nk_textedit_discard_undo(nk_text_undo_state*) @nogc nothrow;
    static void nk_textedit_discard_redo(nk_text_undo_state*) @nogc nothrow;
    static nk_text_undo_record* nk_textedit_create_undo_record(nk_text_undo_state*, int) @nogc nothrow;
    static nk_rune* nk_textedit_createundo(nk_text_undo_state*, int, int, int) @nogc nothrow;
    void nk_textedit_undo(nk_text_edit*) @nogc nothrow;
    void nk_textedit_redo(nk_text_edit*) @nogc nothrow;
    static void nk_textedit_makeundo_insert(nk_text_edit*, int, int) @nogc nothrow;
    static void nk_textedit_makeundo_delete(nk_text_edit*, int, int) @nogc nothrow;
    static void nk_textedit_makeundo_replace(nk_text_edit*, int, int, int) @nogc nothrow;
    static void nk_textedit_clear_state(nk_text_edit*, nk_text_edit_type, nk_plugin_filter) @nogc nothrow;
    void nk_textedit_init_default(nk_text_edit*) @nogc nothrow;
    void nk_textedit_select_all(nk_text_edit*) @nogc nothrow;
    void nk_textedit_free(nk_text_edit*) @nogc nothrow;
    int nk_filter_default(const(nk_text_edit)*, nk_rune) @nogc nothrow;
    int nk_filter_ascii(const(nk_text_edit)*, nk_rune) @nogc nothrow;
    int nk_filter_float(const(nk_text_edit)*, nk_rune) @nogc nothrow;
    int nk_filter_decimal(const(nk_text_edit)*, nk_rune) @nogc nothrow;
    int nk_filter_hex(const(nk_text_edit)*, nk_rune) @nogc nothrow;
    int nk_filter_oct(const(nk_text_edit)*, nk_rune) @nogc nothrow;
    int nk_filter_binary(const(nk_text_edit)*, nk_rune) @nogc nothrow;
    static void nk_edit_draw_text(nk_command_buffer*, const(nk_style_edit)*, float, float, float, const(char)*, int, float, const(nk_user_font)*, nk_color, nk_color, int) @nogc nothrow;
    static nk_flags nk_do_edit(nk_flags*, nk_command_buffer*, nk_rect, nk_flags, nk_plugin_filter, nk_text_edit*, const(nk_style_edit)*, nk_input*, const(nk_user_font)*) @nogc nothrow;
    void nk_edit_focus(nk_context*, nk_flags) @nogc nothrow;
    void nk_edit_unfocus(nk_context*) @nogc nothrow;
    nk_flags nk_edit_string(nk_context*, nk_flags, char*, int*, int, nk_plugin_filter) @nogc nothrow;
    nk_flags nk_edit_buffer(nk_context*, nk_flags, nk_text_edit*, nk_plugin_filter) @nogc nothrow;
    nk_flags nk_edit_string_zero_terminated(nk_context*, nk_flags, char*, int, nk_plugin_filter) @nogc nothrow;
    static void nk_drag_behavior(nk_flags*, const(nk_input)*, nk_rect, nk_property_variant*, float) @nogc nothrow;
    static void nk_property_behavior(nk_flags*, const(nk_input)*, nk_rect, nk_rect, nk_rect, nk_rect, int*, nk_property_variant*, float) @nogc nothrow;
    static void nk_do_property(nk_flags*, nk_command_buffer*, nk_rect, const(char)*, nk_property_variant*, float, char*, int*, int*, int*, int*, int*, const(nk_style_property)*, nk_property_filter, nk_input*, const(nk_user_font)*, nk_text_edit*, nk_button_behavior) @nogc nothrow;
    static nk_property_variant nk_property_variant_int(int, int, int, int) @nogc nothrow;
    static nk_property_variant nk_property_variant_float(float, float, float, float) @nogc nothrow;
    static nk_property_variant nk_property_variant_double(double, double, double, double) @nogc nothrow;
    pragma(mangle, "nk_property") static void nk_property_(nk_context*, const(char)*, nk_property_variant*, float, const(nk_property_filter)) @nogc nothrow;
    void nk_property_double(nk_context*, const(char)*, double, double*, double, double, float) @nogc nothrow;
    int nk_propertyi(nk_context*, const(char)*, int, int, int, int, float) @nogc nothrow;
    float nk_propertyf(nk_context*, const(char)*, float, float, float, float, float) @nogc nothrow;
    double nk_propertyd(nk_context*, const(char)*, double, double, double, double, float) @nogc nothrow;
    void nk_chart_add_slot(nk_context*, const(nk_chart_type), int, float, float) @nogc nothrow;
    static nk_flags nk_chart_push_line(nk_context*, nk_window*, nk_chart*, float, int) @nogc nothrow;
    static nk_flags nk_chart_push_column(const(nk_context)*, nk_window*, nk_chart*, float, int) @nogc nothrow;
    nk_flags nk_chart_push(nk_context*, float) @nogc nothrow;
    void nk_plot(nk_context*, nk_chart_type, const(float)*, int, int) @nogc nothrow;
    static int nk_color_picker_behavior(nk_flags*, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, nk_colorf*, const(nk_input)*) @nogc nothrow;
    static void nk_draw_color_picker(nk_command_buffer*, const(nk_rect)*, const(nk_rect)*, const(nk_rect)*, nk_colorf) @nogc nothrow;
    static int nk_do_color_picker(nk_flags*, nk_command_buffer*, nk_colorf*, nk_color_format, nk_rect, nk_vec2, const(nk_input)*, const(nk_user_font)*) @nogc nothrow;
    int nk_color_pick(nk_context*, nk_colorf*, nk_color_format) @nogc nothrow;
    nk_colorf nk_color_picker(nk_context*, nk_colorf, nk_color_format) @nogc nothrow;
    static int nk_combo_begin(nk_context*, nk_window*, nk_vec2, int, nk_rect) @nogc nothrow;
    int nk_combo_begin_text(nk_context*, const(char)*, int, nk_vec2) @nogc nothrow;
    int nk_combo_begin_label(nk_context*, const(char)*, nk_vec2) @nogc nothrow;
    int nk_combo_begin_color(nk_context*, nk_color, nk_vec2) @nogc nothrow;
    int nk_combo_begin_symbol(nk_context*, nk_symbol_type, nk_vec2) @nogc nothrow;
    int nk_combo_begin_symbol_text(nk_context*, const(char)*, int, nk_symbol_type, nk_vec2) @nogc nothrow;
    int nk_combo_begin_image(nk_context*, nk_image, nk_vec2) @nogc nothrow;
    int nk_combo_begin_image_text(nk_context*, const(char)*, int, nk_image, nk_vec2) @nogc nothrow;
    int nk_combo_item_text(nk_context*, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_combo_item_label(nk_context*, const(char)*, nk_flags) @nogc nothrow;
    int nk_combo_item_image_text(nk_context*, nk_image, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_combo_item_image_label(nk_context*, nk_image, const(char)*, nk_flags) @nogc nothrow;
    int nk_combo_item_symbol_text(nk_context*, nk_symbol_type, const(char)*, int, nk_flags) @nogc nothrow;
    int nk_combo_item_symbol_label(nk_context*, nk_symbol_type, const(char)*, nk_flags) @nogc nothrow;
    void nk_combo_end(nk_context*) @nogc nothrow;
    int nk_combo(nk_context*, const(char)**, int, int, int, nk_vec2) @nogc nothrow;
    int nk_combo_separator(nk_context*, const(char)*, int, int, int, int, nk_vec2) @nogc nothrow;
    int nk_combo_string(nk_context*, const(char)*, int, int, int, nk_vec2) @nogc nothrow;
    int nk_combo_callback(nk_context*, void function(void*, int, const(char)**), void*, int, int, int, nk_vec2) @nogc nothrow;
    void nk_combobox(nk_context*, const(char)**, int, int*, int, nk_vec2) @nogc nothrow;
    void nk_combobox_string(nk_context*, const(char)*, int*, int, int, nk_vec2) @nogc nothrow;
    int nk_tooltip_begin(nk_context*, float) @nogc nothrow;
    void nk_tooltip_end(nk_context*) @nogc nothrow;
    void nk_tooltipf(nk_context*, const(char)*, ...) @nogc nothrow;
}
import derelict.sdl2.sdl;
import derelict.opengl;
import gfm.sdl2;


struct nk_sdl_device {
    nk_buffer cmds;
    nk_draw_null_texture null_texture;
    GLuint vbo, vao, ebo;
    GLuint prog;
    GLuint vert_shdr;
    GLuint frag_shdr;
    GLint attrib_pos;
    GLint attrib_uv;
    GLint attrib_col;
    GLint uniform_tex;
    GLint uniform_proj;
    GLuint font_tex;
}

struct nk_sdl_vertex {
    float[2] position;
    float[2] uv;
    nk_byte[4] col;
}

struct nk_sdl {
    SDL2Window *win;
    nk_sdl_device ogl;
    nk_context ctx;
    nk_font_atlas atlas;
}

static nk_sdl sdl;





    enum NK_SHADER_VERSION = "#version 300 es";


void nk_sdl_device_create()
{
    GLint status;
    static const GLchar *vertex_shader =
        NK_SHADER_VERSION ~ "
        uniform mat4 ProjMtx;
        in vec2 Position;
        in vec2 TexCoord;
        in vec4 Color;
        out vec2 Frag_UV;
        out vec4 Frag_Color;
        void main() {
           Frag_UV = TexCoord;
           Frag_Color = Color;
           gl_Position = ProjMtx * vec4(Position.xy, 0, 1);
        }";
    static const GLchar *fragment_shader =
        NK_SHADER_VERSION ~ "
        precision mediump float;
        uniform sampler2D Texture;
        in vec2 Frag_UV;
        in vec4 Frag_Color;
        out vec4 Out_Color;
        void main(){
           Out_Color = Frag_Color * texture(Texture, Frag_UV.st);
        }";

    nk_sdl_device *dev = &sdl.ogl;
    nk_buffer_init_default(&dev.cmds);
    dev.prog = glCreateProgram();
    dev.vert_shdr = glCreateShader(GL_VERTEX_SHADER);
    dev.frag_shdr = glCreateShader(GL_FRAGMENT_SHADER);
    glShaderSource(dev.vert_shdr, 1, &vertex_shader, null);
    glShaderSource(dev.frag_shdr, 1, &fragment_shader, null);
    glCompileShader(dev.vert_shdr);
    glCompileShader(dev.frag_shdr);
    glGetShaderiv(dev.vert_shdr, GL_COMPILE_STATUS, &status);
    assert(status == GL_TRUE);
    glGetShaderiv(dev.frag_shdr, GL_COMPILE_STATUS, &status);
    assert(status == GL_TRUE);
    glAttachShader(dev.prog, dev.vert_shdr);
    glAttachShader(dev.prog, dev.frag_shdr);
    glLinkProgram(dev.prog);
    glGetProgramiv(dev.prog, GL_LINK_STATUS, &status);
    assert(status == GL_TRUE);

    dev.uniform_tex = glGetUniformLocation(dev.prog, "Texture");
    dev.uniform_proj = glGetUniformLocation(dev.prog, "ProjMtx");
    dev.attrib_pos = glGetAttribLocation(dev.prog, "Position");
    dev.attrib_uv = glGetAttribLocation(dev.prog, "TexCoord");
    dev.attrib_col = glGetAttribLocation(dev.prog, "Color");

    {

        GLsizei vs = nk_sdl_vertex.sizeof;
        size_t vp = nk_sdl_vertex.position.offsetof;
        size_t vt = nk_sdl_vertex.uv.offsetof;
        size_t vc = nk_sdl_vertex.col.offsetof;

        glGenBuffers(1, &dev.vbo);
        glGenBuffers(1, &dev.ebo);
        glGenVertexArrays(1, &dev.vao);

        glBindVertexArray(dev.vao);
        glBindBuffer(GL_ARRAY_BUFFER, dev.vbo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, dev.ebo);

        glEnableVertexAttribArray(cast(GLuint)dev.attrib_pos);
        glEnableVertexAttribArray(cast(GLuint)dev.attrib_uv);
        glEnableVertexAttribArray(cast(GLuint)dev.attrib_col);

        glVertexAttribPointer(cast(GLuint)dev.attrib_pos, 2, GL_FLOAT, GL_FALSE, vs, cast(void*)vp);
        glVertexAttribPointer(cast(GLuint)dev.attrib_uv, 2, GL_FLOAT, GL_FALSE, vs, cast(void*)vt);
        glVertexAttribPointer(cast(GLuint)dev.attrib_col, 4, GL_UNSIGNED_BYTE, GL_TRUE, vs, cast(void*)vc);
    }

    glBindTexture(GL_TEXTURE_2D, 0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
}


void nk_sdl_device_upload_atlas(const void *image, int width, int height)
{
    nk_sdl_device *dev = &sdl.ogl;
    glGenTextures(1, &dev.font_tex);
    glBindTexture(GL_TEXTURE_2D, dev.font_tex);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, cast(GLsizei)width, cast(GLsizei)height, 0,
                GL_RGBA, GL_UNSIGNED_BYTE, image);
}


void nk_sdl_device_destroy()
{
    nk_sdl_device *dev = &sdl.ogl;
    glDetachShader(dev.prog, dev.vert_shdr);
    glDetachShader(dev.prog, dev.frag_shdr);
    glDeleteShader(dev.vert_shdr);
    glDeleteShader(dev.frag_shdr);
    glDeleteProgram(dev.prog);
    glDeleteTextures(1, &dev.font_tex);
    glDeleteBuffers(1, &dev.vbo);
    glDeleteBuffers(1, &dev.ebo);
    nk_buffer_free(&dev.cmds);
}


void nk_sdl_render(nk_anti_aliasing AA, int max_vertex_buffer, int max_element_buffer)
{
    nk_sdl_device *dev = &sdl.ogl;
    int width, height;
    int display_width, display_height;
    nk_vec2 scale;
    GLfloat[4][4] ortho = [
        [2.0f, 0.0f, 0.0f, 0.0f],
        [0.0f,-2.0f, 0.0f, 0.0f],
        [0.0f, 0.0f,-1.0f, 0.0f],
        [-1.0f,1.0f, 0.0f, 1.0f],
    ];

    width = sdl.win.getWidth;
    height = sdl.win.getHeight;

    display_width = width;
    display_height = height;
    ortho[0][0] /= cast(GLfloat)width;
    ortho[1][1] /= cast(GLfloat)height;

    scale.x = cast(float)display_width/cast(float)width;
    scale.y = cast(float)display_height/cast(float)height;


    glViewport(0,0,display_width,display_height);
    glEnable(GL_BLEND);
    glBlendEquation(GL_FUNC_ADD);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glDisable(GL_CULL_FACE);
    glDisable(GL_DEPTH_TEST);
    glEnable(GL_SCISSOR_TEST);
    glActiveTexture(GL_TEXTURE0);


    glUseProgram(dev.prog);
    glUniform1i(dev.uniform_tex, 0);
    glUniformMatrix4fv(dev.uniform_proj, 1, GL_FALSE, &ortho[0][0]);
    {

        const(nk_draw_command)* cmd;
        void* vertices, elements;
        const (nk_draw_index)* offset;
        nk_buffer vbuf, ebuf;


        glBindVertexArray(dev.vao);
        glBindBuffer(GL_ARRAY_BUFFER, dev.vbo);
        glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, dev.ebo);

        glBufferData(GL_ARRAY_BUFFER, max_vertex_buffer, (cast(void*)0), GL_STREAM_DRAW);
        glBufferData(GL_ELEMENT_ARRAY_BUFFER, max_element_buffer, (cast(void*)0), GL_STREAM_DRAW);


        vertices = glMapBuffer(GL_ARRAY_BUFFER, GL_WRITE_ONLY);
        elements = glMapBuffer(GL_ELEMENT_ARRAY_BUFFER, GL_WRITE_ONLY);
        {

            nk_convert_config config;
            static const nk_draw_vertex_layout_element[] vertex_layout = [
                {NK_VERTEX_POSITION, NK_FORMAT_FLOAT, nk_sdl_vertex.position.offsetof},
                {NK_VERTEX_TEXCOORD, NK_FORMAT_FLOAT, nk_sdl_vertex.uv.offsetof},
                {NK_VERTEX_COLOR, NK_FORMAT_R8G8B8A8, nk_sdl_vertex.col.offsetof},
                {NK_VERTEX_ATTRIBUTE_COUNT,NK_FORMAT_COUNT,0}
            ];
            import core.stdc.string : memset;
            memset(&config, 0, config.sizeof);
            config.vertex_layout = vertex_layout.ptr;
            config.vertex_size = nk_sdl_vertex.sizeof;

            config.vertex_alignment = nk_sdl_vertex.alignof;
            config.null_ = dev.null_texture;
            config.circle_segment_count = 22;
            config.curve_segment_count = 22;
            config.arc_segment_count = 22;
            config.global_alpha = 1.0f;
            config.shape_AA = AA;
            config.line_AA = AA;


            nk_buffer_init_fixed(&vbuf, vertices, cast(nk_size)max_vertex_buffer);
            nk_buffer_init_fixed(&ebuf, elements, cast(nk_size)max_element_buffer);
            nk_convert(&sdl.ctx, &dev.cmds, &vbuf, &ebuf, &config);
        }
        glUnmapBuffer(GL_ARRAY_BUFFER);
        glUnmapBuffer(GL_ELEMENT_ARRAY_BUFFER);



        for (cmd = nk__draw_begin(&sdl.ctx, &dev.cmds); cmd !is null; cmd = nk__draw_next(cmd, &dev.cmds, &sdl.ctx))
        {
            if (!cmd.elem_count) continue;
            glBindTexture(GL_TEXTURE_2D, cast(GLuint)cmd.texture.id);
            glScissor(cast(GLint)(cmd.clip_rect.x * scale.x),
                cast(GLint)((height - cast(GLint)(cmd.clip_rect.y + cmd.clip_rect.h)) * scale.y),
                cast(GLint)(cmd.clip_rect.w * scale.x),
                cast(GLint)(cmd.clip_rect.h * scale.y));
            glDrawElements(GL_TRIANGLES, cast(GLsizei)cmd.elem_count, GL_UNSIGNED_SHORT, offset);
            offset += cmd.elem_count;
        }
        nk_clear(&sdl.ctx);
    }

    glUseProgram(0);
    glBindBuffer(GL_ARRAY_BUFFER, 0);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
    glBindVertexArray(0);
    glDisable(GL_BLEND);
    glDisable(GL_SCISSOR_TEST);
}

extern(C)
void nk_sdl_clipbard_paste(nk_handle usr, nk_text_edit* edit)
{
    const char *text = SDL_GetClipboardText();
    if (text) nk_textedit_paste(edit, text, nk_strlen(text));
    cast(void)usr;
}

extern(C)
void nk_sdl_clipbard_copy(nk_handle usr, const char *text, int len)
{
    import core.stdc.string : memcpy;
    char *str;
    cast(void)usr;
    if (!len) return;
    str = cast(char*)malloc(cast(size_t)len+1);
    if (!str) return;
    memcpy(str, text, cast(size_t)len);
    str[len] = '\0';
    SDL_SetClipboardText(str);
    free(str);
}


nk_context* nk_sdl_init(SDL2Window *win)
{
    sdl.win = win;
    nk_init_default(&sdl.ctx, null);
    sdl.ctx.clip.copy = &nk_sdl_clipbard_copy;
    sdl.ctx.clip.paste = &nk_sdl_clipbard_paste;
    sdl.ctx.clip.userdata = nk_handle_ptr(null);
    nk_sdl_device_create();
    return &sdl.ctx;
}


void nk_sdl_font_stash_begin(nk_font_atlas **atlas)
{
    nk_font_atlas_init_default(&sdl.atlas);
    nk_font_atlas_begin(&sdl.atlas);
    *atlas = &sdl.atlas;
}


void nk_sdl_font_stash_end()
{
    const(void)* image; int w, h;
    image = nk_font_atlas_bake(&sdl.atlas, &w, &h, NK_FONT_ATLAS_RGBA32);
    nk_sdl_device_upload_atlas(image, w, h);
    nk_font_atlas_end(&sdl.atlas, nk_handle_id(cast(int)sdl.ogl.font_tex), &sdl.ogl.null_texture);
    if (sdl.atlas.default_font)
        nk_style_set_font(&sdl.ctx, &sdl.atlas.default_font.handle);
}


int nk_sdl_handle_event(SDL_Event *evt)
{
    import core.stdc.string : memcpy;
    nk_context *ctx = &sdl.ctx;
    if (evt.type == SDL_KEYUP || evt.type == SDL_KEYDOWN) {

        int down = evt.type == SDL_KEYDOWN;
        const Uint8* state = SDL_GetKeyboardState(null);
        SDL_Keycode sym = evt.key.keysym.sym;
        if (sym == SDLK_RSHIFT || sym == SDLK_LSHIFT)
            nk_input_key(ctx, NK_KEY_SHIFT, down);
        else if (sym == SDLK_DELETE)
            nk_input_key(ctx, NK_KEY_DEL, down);
        else if (sym == SDLK_RETURN)
            nk_input_key(ctx, NK_KEY_ENTER, down);
        else if (sym == SDLK_TAB)
            nk_input_key(ctx, NK_KEY_TAB, down);
        else if (sym == SDLK_BACKSPACE)
            nk_input_key(ctx, NK_KEY_BACKSPACE, down);
        else if (sym == SDLK_HOME) {
            nk_input_key(ctx, NK_KEY_TEXT_START, down);
            nk_input_key(ctx, NK_KEY_SCROLL_START, down);
        } else if (sym == SDLK_END) {
            nk_input_key(ctx, NK_KEY_TEXT_END, down);
            nk_input_key(ctx, NK_KEY_SCROLL_END, down);
        } else if (sym == SDLK_PAGEDOWN) {
            nk_input_key(ctx, NK_KEY_SCROLL_DOWN, down);
        } else if (sym == SDLK_PAGEUP) {
            nk_input_key(ctx, NK_KEY_SCROLL_UP, down);
        } else if (sym == SDLK_z)
            nk_input_key(ctx, NK_KEY_TEXT_UNDO, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_r)
            nk_input_key(ctx, NK_KEY_TEXT_REDO, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_c)
            nk_input_key(ctx, NK_KEY_COPY, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_v)
            nk_input_key(ctx, NK_KEY_PASTE, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_x)
            nk_input_key(ctx, NK_KEY_CUT, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_b)
            nk_input_key(ctx, NK_KEY_TEXT_LINE_START, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_e)
            nk_input_key(ctx, NK_KEY_TEXT_LINE_END, down && state[SDL_SCANCODE_LCTRL]);
        else if (sym == SDLK_UP)
            nk_input_key(ctx, NK_KEY_UP, down);
        else if (sym == SDLK_DOWN)
            nk_input_key(ctx, NK_KEY_DOWN, down);
        else if (sym == SDLK_LEFT) {
            if (state[SDL_SCANCODE_LCTRL])
                nk_input_key(ctx, NK_KEY_TEXT_WORD_LEFT, down);
            else nk_input_key(ctx, NK_KEY_LEFT, down);
        } else if (sym == SDLK_RIGHT) {
            if (state[SDL_SCANCODE_LCTRL])
                nk_input_key(ctx, NK_KEY_TEXT_WORD_RIGHT, down);
            else nk_input_key(ctx, NK_KEY_RIGHT, down);
        } else return 0;
        return 1;
    } else if (evt.type == SDL_MOUSEBUTTONDOWN || evt.type == SDL_MOUSEBUTTONUP) {

        int down = evt.type == SDL_MOUSEBUTTONDOWN;
        const int x = evt.button.x, y = evt.button.y;
        if (evt.button.button == SDL_BUTTON_LEFT) {
            if (evt.button.clicks > 1)
                nk_input_button(ctx, NK_BUTTON_DOUBLE, x, y, down);
            nk_input_button(ctx, NK_BUTTON_LEFT, x, y, down);
        } else if (evt.button.button == SDL_BUTTON_MIDDLE)
            nk_input_button(ctx, NK_BUTTON_MIDDLE, x, y, down);
        else if (evt.button.button == SDL_BUTTON_RIGHT)
            nk_input_button(ctx, NK_BUTTON_RIGHT, x, y, down);
        return 1;
    } else if (evt.type == SDL_MOUSEMOTION) {

        if (ctx.input.mouse.grabbed) {
            int x = cast(int)ctx.input.mouse.prev.x, y = cast(int)ctx.input.mouse.prev.y;
            nk_input_motion(ctx, x + evt.motion.xrel, y + evt.motion.yrel);
        } else nk_input_motion(ctx, evt.motion.x, evt.motion.y);
        return 1;
    } else if (evt.type == SDL_TEXTINPUT) {

        nk_glyph glyph;
        memcpy(glyph.ptr, evt.text.text.ptr, 4);
        nk_input_glyph(ctx, glyph);
        return 1;
    } else if (evt.type == SDL_MOUSEWHEEL) {

        nk_input_scroll(ctx,nk_vec2(cast(float)evt.wheel.x,cast(float)evt.wheel.y));
        return 1;
    }
    return 0;
}

void nk_sdl_shutdown()
{
    import core.stdc.string : memset;

    nk_font_atlas_clear(&sdl.atlas);
    nk_free(&sdl.ctx);
    nk_sdl_device_destroy();
    memset(&sdl, 0, sdl.sizeof);
}
