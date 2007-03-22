#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <utf.h>
#include <fmt.h>
#include <regexp9.h>

#define SAVEPVN(p,n) ((p) ? savepvn(p,n) : NULL)

START_EXTERN_C

EXTERN_C const regexp_engine engine_plan9;

END_EXTERN_C

regexp *
Plan9_comp(pTHX_ char *exp, char *xend, PMOP *pm)
{
    /* perl regex struct */
    register regexp *r;

    /* pregcomp vars */
    Reprog *re;

    /* regex structure for perl */
    Newxz(r,1,regexp);

    /* have the regex handled by the Plan9 engine */
    r->engine = &engine_plan9;

    /* don't destroy us! */
    r->refcnt = 1;

    /* Preserve a copy of the original pattern */
    r->prelen = xend - exp;
    r->precomp = SAVEPVN(exp, r->prelen);

    /* */
    r->wraplen = r->prelen;
    Newx(r->wrapped, r->wraplen, char);
    Copy(r->precomp, r->wrapped, r->wraplen, char);

    /* Store the flags as perl expects them */
    r->extflags = pm->op_pmflags & RXf_PMf_COMPILETIME;

    re = regcomp(r->precomp);

    if (re == NULL) {
        croak("Can't allocate memory for regcomp");
    }

    /* Save our re */
    r->pprivate = re;

    /* Tell perl how many match vars we have and allocate space for
     * them, at least one is always allocated for $&
     */
    r->nparens = 50;
    Newxz(r->startp, 1+(U32)50, I32);
    Newxz(r->endp, 1+(U32)50, I32);

    /* return the regexp structure to perl */
    return r;
}

I32
Plan9_exec(pTHX_ register regexp *r, char *stringarg, register char *strend,
                  char *strbeg, I32 minend, SV *sv, void *data, U32 flags)
{
    Reprog *re;
    Resub match[50];
    int msize = 50;
    int ret;
    I32 i;
    char *s, *e;
    char *startpos = stringarg;

    re = r->pprivate;

    r->startp[0] = startpos;

    memset(match, 0, msize*sizeof(Resub));

    /* TODO: handle failed matches */
    ret = regexec(re, stringarg, match, msize);

    /* Explicitly documented to return 1 on success */
    if (ret != 1) 
        return 0;

    for (i = 0; match[i].s.sp; i++) {
        s = match[i].s.sp;
        e = match[i].e.ep;

        r->startp[i] = s - stringarg;
        r->endp[i] = e - stringarg;
    }

    /* Tell perl to stop here */
    r->startp[i] = -1;
    r->endp[i]   = -1;

    r->sublen = strend-strbeg;
    r->subbeg = savepvn(strbeg,r->sublen);

    /* matched */
    return 1;
}

char *
Plan9_intuit(pTHX_ regexp *prog, SV *sv, char *strpos,
                     char *strend, U32 flags, re_scream_pos_data *data)
{
    return NULL;
}

SV *
Plan9_checkstr(pTHX_ regexp *prog)
{
    return NULL;
}

void
Plan9_free(pTHX_ struct regexp *r)
{
    free(r->pprivate);
}

void *
Plan9_dupe(pTHX_ const regexp *r, CLONE_PARAMS *param)
{
    return r->pprivate;
}

const regexp_engine engine_plan9 = {
        Plan9_comp,
        Plan9_exec,
        Plan9_intuit,
        Plan9_checkstr,
        Plan9_free,
        Perl_reg_numbered_buff_get,
        Perl_reg_named_buff_get,
#if defined(USE_ITHREADS)        
        Plan9_dupe,
#endif
};

MODULE = re::engine::Plan9	PACKAGE = re::engine::Plan9

void
get_plan9_engine()
PPCODE:
    XPUSHs(sv_2mortal(newSViv(PTR2IV(&engine_plan9))));
