% BibTeX bibliography style for the Aberyswyth School of Education
% Version 0.9.0 (28th of October 2026)

%%%%%%%%%%%%

% ACKNOWLEDGEMENT:
%   This script is a modified version of agsm.bst, which owes much of its functionality to alpha.bst.
% See copyright information at bottom of file, as per `agsm.bst'

%%%%%%%%%%%%

% AUTHOR
%	Slight modifications for Aberystwyth Univeristy: Cyrus Castle (crc18@aber.ac.uk)
%   AGSM:
%   Peter Williams, Key Centre for Design Quality, Sydney University
%   e-mail: peterw@archsci.arch.su.oz.au

%%%%%%%%%%%%

ENTRY
  { address
    annotation
    author
    shortauthor
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
    day
    month
    conference
    conferenceaddress
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    URL
    volume
    year
	accessed
    translator
    writer
    director
    forceextralabel
  }
  { field.used etal.allowed etal.required group.rank } %%%XXX change
  { extra.label sort.label list.year group.year }

INTEGERS { output.state before.all mid.sentence after.block }

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #3 'after.block :=
}

STRINGS { s t f }

INTEGERS { ref.count }

FUNCTION {init.ref.count}
{ #0 'ref.count := }

% Annotation output, written by nst@aber.ac.uk (computer science department at Aber)
FUNCTION {format.annotate}
{ annotation empty$
	{ "" }
	{ " \begin{quotation}\noindent "
		annotation
		* " \end{quotation} " *
	}
	if$
}


FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
	{ add.period$ write$
	  newline$
	  "\newblock " write$
	}
	{ output.state before.all =
	    'write$
	    { add.period$ " " * write$ }
	  if$
	}
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {item.check}
{ 't :=
  empty$
    { "empty " t * " in " * cite$ * warning$ }
    { skip$ }
  if$
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "{\em " swap$ * "}" * }
  if$
}

FUNCTION {quote}
{ duplicate$ empty$
    { pop$ "" }
    { "`" swap$ * "'" * }
  if$
}

FUNCTION {write.url}
{ URL empty$
    { "" } % No URL, no output...
    { accessed empty$
		{ "[online] Available at \url{" URL * "}" * } % Yes URL, no date of access.
		{ "[online] Available at \url{" URL * "} [Accessed: " * accessed * "]" * } % We have all information
      if$
    }
  if$
}

STRINGS { join.a join.b join.sep }

FUNCTION {join.with}
{ 'join.sep :=
  'join.b :=
  'join.a :=
  join.a empty$
    { join.b }
    { join.b empty$
        { join.a }
        { join.a join.sep * join.b * }
      if$
    }
  if$
}

INTEGERS { nameptr namesleft numnames }

FUNCTION {format.names}
{ 's :=
  'f :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr f format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { t "others" =
		{ " \textit{et~al}." * }
		{ " \harvardand\ " * t * }
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
    { editor num.names$ #1 >
        { "{vv~}{ll}{, jj}{, f.}" editor format.names " (eds.)" *}
        { "{vv~}{ll}{, jj}{, f.}" editor format.names " (ed.)" *}
      if$
    }
  if$
}

FUNCTION {format.translators}
{ translator empty$
    { "" }
    { "{vv~}{ll}{, jj}{, f.}" translator format.names }
  if$
}

FUNCTION {format.translators.list}
{ translator empty$
    { "" }
    { "translated by " format.translators *}
  if$
}

FUNCTION {format.title}
{ title field.or.null
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
	{ t #1 #2 substring$ "--" = not
	    { "--" *
	      t #2 global.max$ substring$ 't :=
	    }
	    {   { t #1 #1 substring$ "-" = }
		{ "-" *
		  t #2 global.max$ substring$ 't :=
		}
	      while$
	    }
	  if$
	}
	{ t #1 #1 substring$ *
	  t #2 global.max$ substring$ 't :=
	}
      if$
    }
  while$
}

FUNCTION {format.btitle}
{ title emphasize
}

FUNCTION {format.ttitle}
{ title quote
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { "Vol." volume tie.or.space.connect
      series empty$
	'skip$
	{ " of " * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
	{ series field.or.null }
	{ output.state mid.sentence =
	    { "number" }
	    { "Number" }
	  if$
	  number tie.or.space.connect
	  series empty$
	    { "there's a number but no series in " cite$ * warning$ }
	    { " {\em in} " * series quote * }
	  if$
	}
      if$
    }
    { "" }
  if$
}

FUNCTION {format.address.publisher}
{ address empty$
    { publisher empty$
		{ "" } % a = '', p = ''
		{ publisher } % a = '', p = 'y'

      if$
    }
    { publisher empty$
		{ address } % a = 'x', p = ''
		{ address ": " * publisher *} % a = 'x', p = 'y'
      if$
    }
  if$
}

INTEGERS {non_numeric}

FUNCTION {isnumeric}
{ 't :=
  #0 'non_numeric :=
    { non_numeric not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ chr.to.int$ "9" chr.to.int$ >
      swap$ chr.to.int$ "0" chr.to.int$ <
      or
    	{ #1 'non_numeric := }
    	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  non_numeric not
}

FUNCTION {nthify}
{ duplicate$ isnumeric
    { "\nth{" swap$ * "}" * }
    { skip$ }
    if$
}

FUNCTION {format.newspaper.day.month}
{ day empty$
    { month empty$
        { "" }
        { month }
        if$
    }
    { month empty$
        { day nthify }
        { day nthify " " * month *}
        if$
    }
  if$
}

FUNCTION {format.archive.code}
{ institution empty$
    { number empty$
        { "" }
        { number }
        if$
    }
    { number empty$
        { "archived in " institution * }
        { "archived in " institution * " under catalogue reference " * number *}
        if$
    }
  if$
}

FUNCTION {format.conference.date}
{ day empty$
    { month field.or.null }
    { day nthify month field.or.null " " join.with }
  if$
}

FUNCTION {format.conference.date.address}
{ conference field.or.null
  conferenceaddress field.or.null format.conference.date ", " join.with
  ". " join.with
}

FUNCTION {format.book.edition}
{ edition empty$
    { "" }
    { "(" edition nthify * " Edition)" * }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
	{ edition "l" change.case$ " ed" * }
	{ edition "t" change.case$ " ed" * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
	{ #1 'multiresult := }
	{ t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
	{ "pp.~" pages n.dashify * }
	{ "p.~" pages * }
      if$
    }
  if$
}

FUNCTION {format.article.volume}
{ volume empty$
	{ "" }
    { "vol. " volume *}
  if$
}

FUNCTION {format.article.number}
{ number empty$
	{ "" }
    { "no. " number *}
  if$
}

FUNCTION {format.television.volume}
{ volume empty$
	{ "" }
    { "Series " volume *}
  if$
}

FUNCTION {format.television.number}
{ number empty$
	{ "" }
    { "Episode " number *}
  if$
}

FUNCTION {format.chapter.pages}
{ chapter empty$
    'format.pages
    { type empty$
	{ "chapter" }
	{ type "l" change.case$ }
      if$
      chapter tie.or.space.connect
      pages empty$
	'skip$
	{ ", " * format.pages * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
	{ "in " booktitle emphasize * }
	{ "in " format.editors * " " * booktitle emphasize *}
      if$
    }
  if$
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Technical Report" }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.article.crossref}
{ key empty$
    { journal empty$
	{ "need key or journal for " cite$ * " to crossref " * crossref *
	  warning$
	  ""
	}
	{ "in {\em " journal * "\/} \cite{" * crossref * "}" *}
      if$
    }
    { "{\em in} \citeasnoun{" crossref * "}" * }
  if$

}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "in "
    }
    { "Vol." volume tie.or.space.connect
      " of " *
    }
  if$
  editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ series empty$
	    { "need editor, key, or series for " cite$ * " to crossref " *
	      crossref * warning$
	      "" *
	    }
	    { "{\em " * series * "\/} \cite{" * crossref * "}" *}
	  if$
	}
	{ " \citeasnoun{" * crossref * "}" * }
      if$
    }
    { " \citeasnoun{" * crossref * "}" * }
  if$
}

FUNCTION {format.incoll.inproc.crossref}
{ editor empty$
  editor field.or.null author field.or.null =
  or
    { key empty$
	{ booktitle empty$
	    { "need editor, key, or booktitle for " cite$ * " to crossref " *
	      crossref * warning$
	      ""
	    }
	    { "in {\em " booktitle * "\/}" * " \cite{" * crossref * "}" *}
	  if$
	}
	{ "{\em in} \citeasnoun{" crossref * "}" * }
      if$
    }
    { "{\em in} \citeasnoun{" crossref * "}" * }
  if$

}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

INTEGERS { ind tsslen }

STRINGS { tss ret rss istr }

FUNCTION {replace.substring}{
  'rss :=
  'tss :=
  'istr :=
  "" 'ret :=
  tss text.length$ 'tsslen :=
  #1 'ind :=
    { istr ind tsslen substring$ "" = not }
    { istr ind tsslen substring$ tss =
        { ret rss * 'ret :=
          ind tsslen + 'ind :=
        }
        { ret istr ind #1 substring$ * 'ret :=
          ind #1 + 'ind :=
        }
      if$
    }
  while$
  ret
}

FUNCTION {format.lab.names.abbr}
{ 's :=
  s num.names$ 'numnames :=
  numnames #1 >
    { numnames #2 >
	{ s #1 "{vv~}{ll}" format.name$ " \textit{et~al}." * }
	{ s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { s #1 "{vv~}{ll}" format.name$ " \textit{et~al}." * }
	    { s #1 "{vv~}{ll}" format.name$ " \harvardand\ " *
              s #2 "{vv~}{ll}" format.name$ *
            }
          if$
        }
      if$
    }
    { s #1 "{vv~}{ll}" format.name$ }
  if$
}

FUNCTION {format.lab.names.full}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}" format.name$ 't :=
      nameptr #1 >
	{ namesleft #1 >
	    { ", " * t * }
	    { t "others" =
		{ " \textit{et~al}." * }
		{ " \harvardand\ " * t * }
	      if$
	    }
	  if$
	}
	't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

INTEGERS { author.field editor.field organization.field title.field key.field }

FUNCTION {init.field.constants}
{ #0 'author.field :=
  #1 'editor.field :=
  #2 'organization.field :=
  #3 'title.field :=
  #4 'key.field :=
}

INTEGERS { name.style }

FUNCTION {format.label.names}
{ 's :=
  name.style #0 =
    { "{vv~}{ll}{, jj}{, f.}" s format.names }
    { name.style #1 =
        { s format.lab.names.full }
        { s format.lab.names.abbr }
      if$
    }
  if$
}

FUNCTION {format.label.editors}
{ name.style #0 =
    'format.editors
    { editor format.label.names }
  if$
}

FUNCTION {format.label.title}
{ type$ "television" =
    'format.ttitle
    'format.btitle
  if$
}

FUNCTION {make.label}
{ author.field field.used =
    { author format.label.names }
    { editor.field field.used =
        'format.label.editors
        { organization.field field.used =
            { organization }
            { title.field field.used =
                'format.label.title
                { key.field field.used =
                    { key }
                    { "Internal error :001 on " cite$ * " label" * warning$
                      ""
                    }
                  if$
                }
              if$
            }
          if$
        }
      if$
    }
  if$
}

FUNCTION {make.list.label}
{ #0 'name.style :=
  make.label
}

FUNCTION {make.full.label}
{ #1 'name.style :=
  make.label
}

FUNCTION {make.abbr.label} %%%XXX change
{ shortauthor empty$ not
    { shortauthor }
    { etal.allowed
        { #2 'name.style :=
          make.label
        }
        'make.full.label
      if$
    }
  if$
}

FUNCTION {output.bibitem}
{ newline$
  etal.allowed        %%%XXX change
  etal.required
  and
  shortauthor empty$ not
  or
    {
      "\harvarditem[" write$
      make.abbr.label write$
      "]{" write$
    }
    {
      "\harvarditem{" write$
    }
  if$
  make.full.label write$
  "}{" write$
  list.year write$
  "}{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {list.label.output}
{ make.list.label " " * write$
}


FUNCTION {entry.start}
{ output.bibitem
  list.label.output
  " \harvardyearleft " list.year * "\harvardyearright " * output.nonnull
}

FUNCTION {output.title}
{ title.field field.used =
    'pop$
    'output
  if$
}

FUNCTION {output.title.check}
{ title.field field.used =
    'pop$
    { "title" output.check }
  if$
}

FUNCTION {entry.close}
{ fin.entry
  format.annotate write$
}

FUNCTION {entry.end}
{ write.url output
  new.block
  note output
  entry.close
}

%%%%%%%%%%%%%%%
% ENTRY TYPES %
%%%%%%%%%%%%%%%

FUNCTION {article}
{ entry.start
  author "author" item.check
  format.title quote output.title.check
  crossref missing$
	{ journal emphasize "journal" duplicate$ item.check output
      format.article.volume output
      format.article.number output
      format.pages output
      format.address.publisher output
    }
    { format.article.crossref output.nonnull
      format.pages output
    }
  if$
  entry.end
}

FUNCTION {book.body}
{ author empty$
    { editor "author and editor" item.check }
    { crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  format.btitle output.title.check
  crossref missing$
    { format.bvolume output
      format.number.series output
      format.translators.list output
      format.book.edition output
      format.address.publisher output
    }
    { format.book.crossref output.nonnull
      format.edition output
    }
  if$
}

FUNCTION {book}
{ entry.start
  book.body
  entry.end
}

FUNCTION {inbook}
{ entry.start
  book.body
  format.chapter.pages "chapter and pages" output.check
  entry.end
}

FUNCTION {booklet}
{ entry.start
  format.title quote output.title.check
  howpublished output
  address output
  entry.end
}

FUNCTION {incollection}
{ entry.start
  format.title quote output.title.check
  author "author" item.check
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.bvolume output
      format.number.series output
      format.translators.list output
      format.book.edition output
      format.address.publisher output
      format.chapter.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      format.chapter.pages output
    }
  if$
  entry.end
}

FUNCTION {inproceedings}
{ entry.start
  format.title quote output.title.check
  author "author" item.check
  crossref missing$
    { format.in.ed.booktitle "booktitle" output.check
      format.conference.date.address output
      format.bvolume output
      format.number.series output
      organization output
      format.address.publisher output
    }
    { format.incoll.inproc.crossref output.nonnull }
  if$
  format.pages output
  entry.end
}

FUNCTION {conferencepaper} { inproceedings }

FUNCTION {manual}
{ entry.start
  format.btitle output.title.check
  format.edition output
  author empty$
    { organization empty$
	{ address output }
	'skip$
      if$
    }
    { organization output
      address output
    }
  if$
  entry.end
}

FUNCTION {mastersthesis}
{ entry.start
  author "author" item.check
  format.title output.title.check
  "Master's thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  entry.end
}

FUNCTION {misc}
{ entry.start
  format.title quote output.title
  howpublished output
  entry.end
  empty.misc.check
}

FUNCTION {newspaper}
{ entry.start
  format.title quote output.title
  format.in.ed.booktitle "booktitle" output.check
  format.bvolume output
  format.newspaper.day.month output
  howpublished output
  entry.end
  empty.misc.check
}

FUNCTION {archives}
{ entry.start
  format.title quote output.title
  format.in.ed.booktitle output
  format.address.publisher output
  format.pages output
  format.archive.code output
  entry.end
  empty.misc.check
}

FUNCTION {television}
{ entry.start
  format.title quote output.title
  booktitle emphasize output
  publisher output
  format.television.volume output
  format.television.number output
  format.newspaper.day.month output
  howpublished output
  entry.end
  empty.misc.check
}

FUNCTION {law.end}
{ howpublished output
  write.url output
  new.block
  entry.close
  empty.misc.check
}

FUNCTION {britishlaw}
{ output.bibitem
  "{\em " title * " " * year * " c." * chapter * "}" * output
  law.end
}

FUNCTION {devolvedlaw}
{ output.bibitem
  "{\em " title * " " * year * " (" * chapter * ")}" * output
  law.end
}

FUNCTION {phdthesis}
{ entry.start
  author "author" item.check
  format.btitle output.title.check
  "PhD thesis" format.thesis.type output.nonnull
  school "school" output.check
  address output
  entry.end
}

FUNCTION {proceedings}
{ entry.start
  format.btitle output.title.check
  format.bvolume output
  format.number.series output
  address empty$
    { editor empty$
	{ skip$ }
	{ organization output
	}
      if$
      publisher output
    }
    { editor empty$
	'skip$
	{ organization output }
      if$
      publisher output
      address output.nonnull
    }
  if$
  entry.end
}

FUNCTION {techreport}
{ entry.start
  author "author" item.check
  format.title output.title.check
  format.tr.number output.nonnull
  institution "institution" output.check
  address output
  entry.end
}

FUNCTION {unpublished}
{ entry.start
  author "author" item.check
  format.title output.title.check
  write.url output
  new.block
  note "note" output.check
  entry.close
}

%%%%%%%%%%%%%%%%
% BACK TO WORK %
%%%%%%%%%%%%%%%%

FUNCTION {default.type} { misc }

MACRO {jan} {"January"}

MACRO {feb} {"February"}

MACRO {mar} {"March"}

MACRO {apr} {"April"}

MACRO {may} {"May"}

MACRO {jun} {"June"}

MACRO {jul} {"July"}

MACRO {aug} {"August"}

MACRO {sep} {"September"}

MACRO {oct} {"October"}

MACRO {nov} {"November"}

MACRO {dec} {"December"}

READ

EXECUTE {init.field.constants}

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

FUNCTION {sortify.names}
{ " \harvardand\ " " " replace.substring
  " \textit{et~al}." " zzz" replace.substring
  sortify
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
	{ title.field 'field.used := }
	{ key.field 'field.used := }
      if$
    }
    { author.field 'field.used := }
  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
	{ key empty$
	    { title.field 'field.used := }
	    { key.field 'field.used := }
	  if$
  	}
	{ editor.field 'field.used := }
      if$
    }
    { author.field 'field.used := }
  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
	{ organization empty$
	    { title.field 'field.used := }
	    { organization.field 'field.used := }
	  if$
	}
	{ key.field 'field.used := }
      if$
    }
    { author.field 'field.used := }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
	{ organization empty$
	    { title.field 'field.used := }
	    { organization.field 'field.used := }
	  if$
	}
	{ key.field 'field.used := }
      if$
    }
    { editor.field 'field.used := }
  if$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {calc.label} %%%XXX change
{ make.abbr.label
  title.field field.used =
    { sort.format.title }
    { sortify.names }
  if$
  year field.or.null purify$ #-1 #4 substring$ sortify
  *
  'sort.label :=
}

FUNCTION {preliminaries} %%%XXX change
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
	'editor.key.organization.label
	{ type$ "manual" =
	    'author.key.organization.label
	    'author.key.label
	  if$
	}
      if$
    }
  if$
  author.field field.used = %%%XXX change
    {
      author num.names$ #2 >
        { #1 }
        { #0 }
      if$
      'etal.required :=
    }
    {
      editor.field field.used =
        {
          editor num.names$ #2 >
            { #1 }
            { #0 }
          if$
        }
        { #0 }
      if$
      'etal.required :=
    }
  if$
  #1 'etal.allowed :=
}

FUNCTION {first.presort}
{ calc.label
  sort.label
  "    " *
  forceextralabel empty$
    { "1" }
    { "0" forceextralabel sortify * }
  if$
  *
  title.field field.used =
    { skip$ }
    { "    "
      *
      make.list.label sortify.names
      *
      "    "
      *
      title field.or.null
      sort.format.title
      *
    }
  if$
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {preliminaries}

ITERATE {first.presort}

SORT

STRINGS { last.sort.label last.full.label }

INTEGERS { last.extra.num last.etal.allowed }

FUNCTION {initialize.confusion}
{ #0 int.to.chr$ 'last.sort.label :=
  #0 int.to.chr$ 'last.full.label :=
  #1 'last.etal.allowed :=
}

FUNCTION {confusion.pass}
{ last.sort.label sort.label =
    { last.etal.allowed
        { last.full.label make.full.label sortify.names =
            { skip$ }
            { #0 'etal.allowed :=
              #0 'last.etal.allowed :=
            }
          if$
        }
        { #0 'etal.allowed := }
      if$
    }
    { sort.label 'last.sort.label :=
      make.full.label sortify.names 'last.full.label :=
      #1 'last.etal.allowed :=
    }
  if$
}

EXECUTE {initialize.confusion}

ITERATE {confusion.pass}

EXECUTE {initialize.confusion}

REVERSE {confusion.pass}

STRINGS { last.group.year next.sort.label }

INTEGERS { last.group.rank }

FUNCTION {initialize.last.extra.num}
{ #0 int.to.chr$ 'last.sort.label :=
  "a" chr.to.int$ #1 - 'last.extra.num :=
  #0 'last.group.rank :=
  "" 'last.group.year :=
}

% Is the string on the stack a single lowercase letter?
FUNCTION {is.single.letter}
{ 't :=
  t text.length$ #1 =
    { t chr.to.int$ "a" chr.to.int$ < not
      t chr.to.int$ "z" chr.to.int$ > not
      and
    }
    { #0 }
  if$
}

FUNCTION {forward.pass}
{ last.sort.label sort.label =
    { last.group.rank #1 + 'last.group.rank := }
    { sort.label 'last.sort.label :=
      "a" chr.to.int$ #1 - 'last.extra.num :=
      #0 'last.group.rank :=
      year empty$
        { "n.d." }
        { year }
      if$
      'last.group.year :=
    }
  if$
  last.group.rank 'group.rank :=
  last.group.year 'group.year :=
  forceextralabel empty$
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { forceextralabel 'extra.label :=
      forceextralabel is.single.letter
        { forceextralabel chr.to.int$ 'last.extra.num := }
        'skip$
      if$
    }
  if$
}

FUNCTION {initialize.next.sort.label}
{ #0 int.to.chr$ 'next.sort.label :=
}

FUNCTION {reverse.pass}
{ forceextralabel empty$
  extra.label "a" =
  and
  next.sort.label sort.label = not
  and
    { "" 'extra.label := }
    'skip$
  if$
  year empty$
    { "n.d." extra.label emphasize * 'list.year := }
    { year extra.label emphasize * 'list.year := }
  if$
  sort.label 'next.sort.label :=
}

ITERATE {first.presort}

SORT

EXECUTE {initialize.last.extra.num}

ITERATE {forward.pass}

EXECUTE {initialize.next.sort.label}

REVERSE {reverse.pass}

FUNCTION {second.presort}
{ make.list.label
  title.field field.used =
    { sort.format.title }
    { sortify.names }
  if$
  "    "
  *
  group.year sortify
  *
  extra.label empty$
    { "" }
    { group.rank "a" chr.to.int$ + int.to.chr$ }
  if$
  *
  "    "
  *
  title.field field.used =
    { skip$ }
    { title field.or.null
      sort.format.title
      *
    }
  if$
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {second.presort}

SORT

FUNCTION {create.extra.outputs}
{ "\expandafter\def\csname bibtitler@" cite$ * "\endcsname{" * title * "}" * write$ }

ITERATE {create.extra.outputs}

EXECUTE {init.ref.count}

FUNCTION {count.references}
{ ref.count #1 + 'ref.count := }

ITERATE {count.references}

FUNCTION {output.ref.count}
{ ref.count number$ int.to.str$ 't :=
  "\makeatletter\@ifundefined{aber@writerefcount}{\immediate\write\@auxout{\gdef\string\refcount{"
  t * "}}}{\aber@writerefcount{" * t * "}}\makeatother" *
  write$
}

EXECUTE {output.ref.count}

FUNCTION {begin.bib}
{ preamble$ empty$
    'skip$
    { "\harvardpreambledefs{%" write$ newline$
      preamble$ write$ "}" write$ newline$
      "\harvardpreambletext{%" write$ newline$
      preamble$ write$ "}" write$ newline$ }
  if$
  "\begin{thebibliography}{xx}" write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}


% Adapted from the BibTeX standard bibliography style `agsm' (one of the harvard family)
	% version 0.99a for BibTeX versions 0.99a or later, LaTeX version 2.09.
	% Copyright (C) 1991, all rights reserved.
	% Copying of this file is authorized only if either
	% (1) you make absolutely no changes to your copy, including name, or
	% (2) if you do make changes, you name it something other than
	% btxbst.doc, plain.bst, unsrt.bst, alpha.bst, abbrv.bst, agsm.bst,
        % dcu.bst or kluwer.bst.
	% This restriction helps ensure that all standard styles are identical.
	% The file harvard.tex has the documentation for this style.
