SED(1)                           User Commands                          SED(1)



NNAAMMEE
       sed - stream editor for filtering and transforming text

SSYYNNOOPPSSIISS
       sseedd [_O_P_T_I_O_N]... _{_s_c_r_i_p_t_-_o_n_l_y_-_i_f_-_n_o_-_o_t_h_e_r_-_s_c_r_i_p_t_} [_i_n_p_u_t_-_f_i_l_e]...

DDEESSCCRRIIPPTTIIOONN
       _S_e_d  is a stream editor.  A stream editor is used to perform basic text
       transformations on an input stream (a file or input from  a  pipeline).
       While  in  some  ways similar to an editor which permits scripted edits
       (such as _e_d), _s_e_d works by making only one pass over the input(s),  and
       is consequently more efficient.  But it is _s_e_d's ability to filter text
       in a pipeline which particularly distinguishes it from other  types  of
       editors.

       --nn, ----qquuiieett, ----ssiilleenntt

              suppress automatic printing of pattern space

       --ee script, ----eexxpprreessssiioonn=_s_c_r_i_p_t

              add the script to the commands to be executed

       --ff script-file, ----ffiillee=_s_c_r_i_p_t_-_f_i_l_e

              add the contents of script-file to the commands to be executed

       ----ffoollllooww--ssyymmlliinnkkss

              follow symlinks when processing in place

       --ii[[SSUUFFFFIIXX]], ----iinn--ppllaaccee[=_S_U_F_F_I_X]

              edit files in place (makes backup if SUFFIX supplied)

       --ll N, ----lliinnee--lleennggtthh=_N

              specify the desired line-wrap length for the `l' command

       ----ppoossiixx

              disable all GNU extensions.

       --rr, ----rreeggeexxpp--eexxtteennddeedd

              use extended regular expressions in the script.

       --ss, ----sseeppaarraattee

              consider  files  as  separate rather than as a single continuous
              long stream.

       --uu, ----uunnbbuuffffeerreedd

              load minimal amounts of data from the input files and flush  the
              output buffers more often

       --zz, ----nnuullll--ddaattaa

              separate lines by NUL characters

       ----hheellpp
              display this help and exit

       ----vveerrssiioonn
              output version information and exit

       If  no  --ee, ----eexxpprreessssiioonn, --ff, or ----ffiillee option is given, then the first
       non-option argument is taken as  the  sed  script  to  interpret.   All
       remaining  arguments  are  names  of input files; if no input files are
       specified, then the standard input is read.

       GNU sed home page:  <http://www.gnu.org/software/sed/>.   General  help
       using  GNU software: <http://www.gnu.org/gethelp/>.  E-mail bug reports
       to: <bug-sed@gnu.org>.  Be sure to include the word  ``sed''  somewhere
       in the ``Subject:'' field.

CCOOMMMMAANNDD SSYYNNOOPPSSIISS
       This is just a brief synopsis of _s_e_d commands to serve as a reminder to
       those who already know _s_e_d; other documentation (such  as  the  texinfo
       document) must be consulted for fuller descriptions.

   ZZeerroo--aaddddrreessss ````ccoommmmaannddss''''
       : _l_a_b_e_l
              Label for bb and tt commands.

       #_c_o_m_m_e_n_t
              The  comment  extends until the next newline (or the end of a --ee
              script fragment).

       }      The closing bracket of a { } block.

   ZZeerroo-- oorr OOnnee-- aaddddrreessss ccoommmmaannddss
       =      Print the current line number.

       a \

       _t_e_x_t   Append _t_e_x_t, which has each embedded newline preceded by a back‐
              slash.

       i \

       _t_e_x_t   Insert _t_e_x_t, which has each embedded newline preceded by a back‐
              slash.

       q [_e_x_i_t_-_c_o_d_e]
              Immediately quit the _s_e_d  script  without  processing  any  more
              input,  except  that  if  auto-print is not disabled the current
              pattern space will be printed.  The exit code argument is a  GNU
              extension.

       Q [_e_x_i_t_-_c_o_d_e]
              Immediately  quit  the  _s_e_d  script  without processing any more
              input.  This is a GNU extension.

       r _f_i_l_e_n_a_m_e
              Append text read from _f_i_l_e_n_a_m_e.

       R _f_i_l_e_n_a_m_e
              Append a line read from _f_i_l_e_n_a_m_e.  Each invocation of  the  com‐
              mand reads a line from the file.  This is a GNU extension.

   CCoommmmaannddss wwhhiicchh aacccceepptt aaddddrreessss rraannggeess
       {      Begin a block of commands (end with a }).

       b _l_a_b_e_l
              Branch to _l_a_b_e_l; if _l_a_b_e_l is omitted, branch to end of script.

       c \

       _t_e_x_t   Replace  the  selected  lines with _t_e_x_t, which has each embedded
              newline preceded by a backslash.

       d      Delete pattern space.  Start next cycle.

       D      If pattern space contains no newline, start a normal  new  cycle
              as  if  the d command was issued.  Otherwise, delete text in the
              pattern space up to the first newline, and  restart  cycle  with
              the  resultant  pattern  space,  without  reading  a new line of
              input.

       h H    Copy/append pattern space to hold space.

       g G    Copy/append hold space to pattern space.

       l      List out the current line in a ``visually unambiguous'' form.

       l _w_i_d_t_h
              List out the current line in a  ``visually  unambiguous''  form,
              breaking it at _w_i_d_t_h characters.  This is a GNU extension.

       n N    Read/append the next line of input into the pattern space.

       p      Print the current pattern space.

       P      Print  up  to  the first embedded newline of the current pattern
              space.

       s/_r_e_g_e_x_p/_r_e_p_l_a_c_e_m_e_n_t/
              Attempt to match _r_e_g_e_x_p against the pattern space.  If  success‐
              ful,   replace  that  portion  matched  with  _r_e_p_l_a_c_e_m_e_n_t.   The
              _r_e_p_l_a_c_e_m_e_n_t may contain the special character && to refer to that
              portion  of  the  pattern  space  which matched, and the special
              escapes \1 through \9 to refer  to  the  corresponding  matching
              sub-expressions in the _r_e_g_e_x_p.

       t _l_a_b_e_l
              If  a  s///  has  done  a successful substitution since the last
              input line was read and since the last  t  or  T  command,  then
              branch to _l_a_b_e_l; if _l_a_b_e_l is omitted, branch to end of script.

       T _l_a_b_e_l
              If  no  s///  has  done a successful substitution since the last
              input line was read and since the last  t  or  T  command,  then
              branch  to  _l_a_b_e_l; if _l_a_b_e_l is omitted, branch to end of script.
              This is a GNU extension.

       w _f_i_l_e_n_a_m_e
              Write the current pattern space to _f_i_l_e_n_a_m_e.

       W _f_i_l_e_n_a_m_e
              Write the first line of the current pattern space  to  _f_i_l_e_n_a_m_e.
              This is a GNU extension.

       x      Exchange the contents of the hold and pattern spaces.

       y/_s_o_u_r_c_e/_d_e_s_t/
              Transliterate  the  characters in the pattern space which appear
              in _s_o_u_r_c_e to the corresponding character in _d_e_s_t.

AAddddrreesssseess
       _S_e_d commands can be given with no addresses, in which case the  command
       will  be  executed for all input lines; with one address, in which case
       the command will only be executed for  input  lines  which  match  that
       address;  or with two addresses, in which case the command will be exe‐
       cuted for all input lines which match  the  inclusive  range  of  lines
       starting  from  the first address and continuing to the second address.
       Three things to note about address ranges: the  syntax  is  _a_d_d_r_1,_a_d_d_r_2
       (i.e.,  the  addresses  are separated by a comma); the line which _a_d_d_r_1
       matched will always be accepted, even if _a_d_d_r_2 selects an earlier line;
       and  if  _a_d_d_r_2 is a _r_e_g_e_x_p, it will not be tested against the line that
       _a_d_d_r_1 matched.

       After the address (or address-range), and before the command, a !!   may
       be inserted, which specifies that the command shall only be executed if
       the address (or address-range) does nnoott match.

       The following address types are supported:

       _n_u_m_b_e_r Match only the specified line _n_u_m_b_e_r (which  increments  cumula‐
              tively  across  files,  unless the --ss option is specified on the
              command line).

       _f_i_r_s_t~_s_t_e_p
              Match every _s_t_e_p'th line starting with line _f_i_r_s_t.  For example,
              ``sed  -n  1~2p''  will  print all the odd-numbered lines in the
              input stream, and the address 2~5 will match every  fifth  line,
              starting  with the second.  _f_i_r_s_t can be zero; in this case, _s_e_d
              operates as if it were equal to _s_t_e_p.  (This is an extension.)

       $      Match the last line.

       /_r_e_g_e_x_p/
              Match lines matching the regular expression _r_e_g_e_x_p.

       \cc_r_e_g_e_x_pcc
              Match lines matching the regular expression _r_e_g_e_x_p.  The  cc  may
              be any character.

       GNU _s_e_d also supports some special 2-address forms:

       0,_a_d_d_r_2
              Start  out  in  "matched  first  address"  state, until _a_d_d_r_2 is
              found.  This is similar to 1,_a_d_d_r_2, except that if _a_d_d_r_2 matches
              the very first line of input the 0,_a_d_d_r_2 form will be at the end
              of its range, whereas the 1,_a_d_d_r_2 form  will  still  be  at  the
              beginning of its range.  This works only when _a_d_d_r_2 is a regular
              expression.

       _a_d_d_r_1,+_N
              Will match _a_d_d_r_1 and the _N lines following _a_d_d_r_1.

       _a_d_d_r_1,~_N
              Will match _a_d_d_r_1 and the lines following _a_d_d_r_1  until  the  next
              line whose input line number is a multiple of _N.

RREEGGUULLAARR EEXXPPRREESSSSIIOONNSS
       POSIX.2 BREs _s_h_o_u_l_d be supported, but they aren't completely because of
       performance problems.  The \\nn sequence in a regular expression  matches
       the newline character, and similarly for \\aa, \\tt, and other sequences.

BBUUGGSS
       E-mail bug reports to bbuugg--sseedd@@ggnnuu..oorrgg.  Also, please include the output
       of ``sed --version'' in the body of your report if at all possible.

AAUUTTHHOORR
       Written by Jay Fenlason, Tom Lord, Ken Pizzini, and Paolo Bonzini.  GNU
       sed  home page: <http://www.gnu.org/software/sed/>.  General help using
       GNU software: <http://www.gnu.org/gethelp/>.  E-mail  bug  reports  to:
       <bug-sed@gnu.org>.   Be  sure  to include the word ``sed'' somewhere in
       the ``Subject:'' field.

CCOOPPYYRRIIGGHHTT
       Copyright © 2012 Free Software Foundation, Inc.   License  GPLv3+:  GNU
       GPL version 3 or later <http://gnu.org/licenses/gpl.html>.
       This  is  free  software:  you  are free to change and redistribute it.
       There is NO WARRANTY, to the extent permitted by law.

SSEEEE AALLSSOO
       aawwkk(1), eedd(1), ggrreepp(1), ttrr(1),  ppeerrllrree(1),  sed.info,  any  of  various
       books on _s_e_d, the _s_e_d FAQ (http://sed.sf.net/grabbag/tutorials/sed‐
       faq.txt), http://sed.sf.net/grabbag/.

       The full documentation for sseedd is maintained as a Texinfo manual.  If
       the iinnffoo and sseedd programs are properly installed at your site, the com‐
       mand

              iinnffoo sseedd

       should give you access to the complete manual.



sed 4.2.2                        December 2012                          SED(1)
