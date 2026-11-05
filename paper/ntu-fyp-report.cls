\ProvidesClass{ntu-fyp-report}[2026/04/13 v0.1 NTU Final Year Project Report]
\NeedsTeXFormat{LaTeX2e}

\LoadClass[
    11pt,
    openright,
    oneside,
]{report}

% ------------------------------------------------------------------------------
% Basics

\usepackage[
    a4paper,
    margin=3cm,
]{geometry}

% UTF-8 input.
\usepackage[utf8]{inputenc}

% Makes ligatures readable in the pdf.
\input{glyphtounicode}
\pdfgentounicode=1

% Font
\usepackage[T1]{fontenc}
\usepackage[
    rm={lining,tabular},
    sf={lining,tabular},
    tt={lining,tabular,monowidth}
]{cfr-lm}
\usepackage[defaultsans,scale=0.90]{opensans}
\linespread{1.1}

\DeclareRobustCommand\ebseries{\fontseries{eb}\selectfont}
\DeclareRobustCommand\sbseries{\fontseries{sb}\selectfont}
\DeclareRobustCommand\meseries{\fontseries{m}\selectfont}
\DeclareRobustCommand\ltseries{\fontseries{l}\selectfont}
\DeclareRobustCommand\clseries{\fontseries{cl}\selectfont}

\DeclareTextFontCommand{\texteb}{\ebseries}
\DeclareTextFontCommand{\textsb}{\sbseries}
\DeclareTextFontCommand{\textme}{\meseries}
\DeclareTextFontCommand{\textlt}{\ltseries}
\DeclareTextFontCommand{\textcl}{\clseries}


% Microtype
\usepackage[kerning=true]{microtype}

% Document in English
\usepackage[british]{babel}

% AMS packages
\usepackage{amsmath}
\usepackage{amsfonts}
\usepackage{amssymb}

% Allows to include pictures
\usepackage{graphicx}

% Links and metadata for pdf-file
\usepackage[
    pdfusetitle,
]{hyperref}
\hypersetup{
    unicode,
    pdfborder = 0 0 0,
}

% Allow colours.
\usepackage[]{xcolor}
\definecolor{ntuBlue}{HTML}{181c62}
\definecolor{ntuRed}{HTML}{d71440}

% More if-clauses
\usepackage[]{xifthen}
\newcommand{\ifNotEmpty}[2]{%
    \ifthenelse{\equal{#1}{\empty}}{}{#2}%
}

% Use symbols for footnotes.
\renewcommand{\thefootnote}{\fnsymbol{footnote}}


% ------------------------------------------------------------------------------
% Title Page

\makeatletter

\gdef\@project{}
\gdef\@supervisor{}
\gdef\@examiner{}
\gdef\@school{}
\gdef\@schoolyear{}

\newcommand{\project}[1]{\gdef\@project{#1}}
\newcommand{\supervisor}[1]{\gdef\@supervisor{#1}}
\newcommand{\examiner}[1]{\gdef\@examiner{#1}}
\newcommand{\school}[1]{\gdef\@school{#1}}
\newcommand{\schoolyear}[1]{\gdef\@schoolyear{#1}}

\renewcommand{\maketitle}{%
\begin{center}%
    \thispagestyle{empty}%
    \ntuLogoTikZ%

    \vspace*{3cm} % same as page margin

    {
        \Large
        \@author
        \par
    }

    \bigskip

    {
        \linespread{1.4}
        \huge\bfseries
        \@title
        \par
    }

    \vspace*{\fill}

    \begin{tabular}{r@{~}l}
        \ifNotEmpty{\@supervisor}{%
            Supervisor: & \@supervisor \\ \noalign{\medskip}
        }%
        \ifNotEmpty{\@examiner}{%
            Examiner: & \@examiner
        }%
    \end{tabular}

    \vspace*{2.66cm}

    \ifNotEmpty{\@project}{\@project}

    \medskip

    \@school, \@schoolyear%
\end{center}%
\clearpage
\if@openright\clearpage\thispagestyle{empty}\fi
}

% ------------------------------------------------------------------------------
% Chapters and Sections

\gdef\@thisChapter{}
\newcommand{\@setChapter}[1]{\gdef\@thisChapter{#1}}

% Adds all chapters to table of contents.
\renewcommand{\@schapter}[1]{
    \phantomsection
    \addcontentsline{toc}{chapter}{#1}
    \@makeschapterhead{#1}%
    \@afterheading
}

% Basic format for chapters. 
\newcommand{\@chapterStyle}{
    \parindent \z@
    \setlength{\parskip}{1em}
    \interlinepenalty\@M

    \raggedright
    \rmfamily
    \bfseries\boldmath

    \huge

    \newcommand{\chapterNote}[1]{%
        \renewcommand{\thefootnote}{\raisebox{0.3ex}{\normalsize$\star$}}%
        \footnotemark%
        \renewcommand{\thefootnote}{$\star$}%
        \footnotetext{##1}%
        \setcounter{footnote}{0}%
    }
}

% Chapter headlines with number.
\renewcommand{\@makechapterhead}[1]{{%
    \@setChapter{\@chapapp\ \thechapter:\enspace #1}
    \@chapterStyle
    \parbox[t][25\p@]{\linewidth}{
        \ifnum \c@secnumdepth >\m@ne \vspace{\fill}
            \normalsize \normalfont \@chapapp\space \thechapter
        \fi
    }
    \par\nobreak  \vskip 5\p@
    #1 \par\nobreak
    \vskip 40\p@
}}

% Chapter headlines without number.
\renewcommand{\@makeschapterhead}[1]{{%
    \@setChapter{#1}
    \@chapterStyle
    \parbox[t][25\p@]{\linewidth}{}
    \par\nobreak  \vskip 5\p@
    #1 \par\nobreak
    \vskip 40\p@
}}


\renewcommand{\section}{%
    \@startsection{section}{1}{\z@}{%
        -18\p@ \@plus -4\p@ \@minus -4\p@%
    }{%
        12\p@ \@plus 4\p@ \@minus 4\p@%
    }{%
        \normalfont%
        \Large%
        \bfseries%
        \boldmath%
        \rightskip=\z@ \@plus 8em%
        \pretolerance=10000%
    }%
}

\renewcommand{\subsection}{%
    \@startsection{subsection}{2}{\z@}{%
        -18\p@ \@plus -4\p@ \@minus -4\p@%
    }{%
        8\p@ \@plus 4\p@ \@minus 4\p@%
    }{%
        \normalfont%
        \large%
        \bfseries%
        \boldmath%
        \rightskip=\z@ \@plus 8em%
        \pretolerance=10000%
    }%
}

\renewcommand{\subsubsection}{%
    \@startsection{subsubsection}{3}{\z@}{%
        -18\p@ \@plus -4\p@ \@minus -4\p@%
    }{%
        -0.75em \@plus -0.25em \@minus -0.2em%
    }{%
        \normalfont%
        \normalsize%
        \bfseries%
        \boldmath%
    }%
}

\renewcommand{\paragraph}{%
    \@startsection{paragraph}{4}{\z@}{%
        -12\p@ \@plus -4\p@ \@minus -4\p@%
    }{%
        -0.75em \@plus -0.25em \@minus -0.2em%
    }{%
        \normalfont%
        \normalsize%
        \itshape%
    }%
}

% No sub-paragraph posible.
\let\subparagraph\undefined

% ------------------------------------------------------------------------------
% Captions (for figures, tables, ...)

\usepackage[font={small,sf}]{caption}
\DeclareCaptionFormat{plain}{\textsb{#1}#2#3}
\DeclareCaptionLabelSeparator{dot}{. }
\captionsetup{labelsep=dot}

% Subfigures
\usepackage{subcaption}
\captionsetup{subrefformat=parens}

% No indent for entryies in List of Tables/Figures.
\renewcommand*\l@figure{\@dottedtocline{1}{0em}{2.3em}}
\renewcommand*\l@table{\@dottedtocline{1}{0em}{2.3em}}


% ------------------------------------------------------------------------------
% Table of Contents

% Adds `\boldmath`.
\renewcommand*\l@chapter[2]{%
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip 1.0em \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \bfseries\boldmath
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak\hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi%
}

% ------------------------------------------------------------------------------
% Headers and Footers

\def\ps@headings{%
    \def\@oddhead{%
        \parbox[b][\headheight][b]{\textwidth}{%
            \hfill\@thisChapter\par%
            \noindent\rule{\textwidth}{0.4pt}%
        }%
    }%
    \def\@evenhead{%
        \parbox[b][\headheight][b]{\textwidth}{%
            \@thisChapter\par%
            \noindent\rule{\textwidth}{0.4pt}%
        }%
    }%
    \def\@oddfoot{%
        \parbox[t][\headheight][t]{\textwidth}{%
            \noindent\rule{\textwidth}{0.4pt}\par%
            \hfill\thepage%
        }%
    }
    \def\@evenfoot{%
        \parbox[t][\headheight][t]{\textwidth}{%
            \noindent\rule{\textwidth}{0.4pt}\par%
            \thepage%
        }%
    }
}

\def\ps@plain{%
    \def\@oddhead{%
        \parbox[b][\headheight][b]{\textwidth}{%
            \noindent\rule{\textwidth}{0.4pt}%
        }%
    }%
    \def\@oddfoot{%
        \parbox[t][\headheight][t]{\textwidth}{%
            \noindent\rule{\textwidth}{0.4pt}\par%
            \hfill\thepage%
        }%
    }
}

\pagestyle{headings}

% ------------------------------------------------------------------------------
% Lists

\usepackage[
    inline,
    shortlabels,
]{enumitem}

\setlist[1,2]{
    topsep=2pt plus 2pt minus 2pt,
    partopsep=0pt,
    parsep=0pt,
    itemsep=2pt plus 2pt minus 2pt,
}

% ------------------------------------------------------------------------------
% Theorems

% Global counter for custom labels.
\newcounter{glLabelCounter}
\newcommand{\setLabel}[1]{%
    \refstepcounter{glLabelCounter}%
    \protected@edef\@currentlabel{#1}%
}

% Counter for theorem environments.
\newcounter{thrmCounter}[chapter]%
\newcommand{\thrmNo}{%
    \thechapter.\the\value{thrmCounter}%
}

\newcommand{\@thrmCiteArg}[1][]{%
    \ifthenelse{\equal{#1}{\empty}}{%
        \unskip \hskip 0.5em%
    }{%
        \unskip \hskip 0.5em%
        {\upshape #1}%
    }%
}

% Creates a theorem environment.
%   #1: Code name
%   #2: Display name
%   #3: Header font
%   #4: Body font
\newcommand{\createTheorem}[4]{%
    \newenvironment{#1}[1][]{%
        \trivlist\item%
        \stepcounter{thrmCounter}%
        \setLabel{\thrmNo}{%
            #3#2\unskip~\thrmNo%
            \ifNotEmpty{##1}{%
                ~(##1)%
            }%
            .%
        }%
        #4%
        \@ifnextchar[{%
            \@thrmCiteArg%
        }{
            \unskip \hskip 0.5em%
        }%
    }{%
        \endtrivlist
    }%
}

% Theorem
\createTheorem{theorem}{%
    Theorem
}{%
    \rmfamily
    \bfseries
    \boldmath
}{%
    \itshape
}

% Lemma
\createTheorem{lemma}{%
    Lemma
}{%
    \rmfamily
    \bfseries
    \boldmath
}{%
    \itshape
}

% Observation
\createTheorem{observation}{%
    Observation
}{
    \rmfamily
    \bfseries
    \boldmath
}{%
    \itshape
}

% Corollary
\createTheorem{corollary}{%
    Corollary
}{
    \rmfamily
    \bfseries
    \boldmath
}{%
    \itshape
}

% Conjecture
\createTheorem{conjecture}{%
    Conjecture
}{
    \rmfamily
    \bfseries
    \boldmath
}{%
    \itshape
}

% Definition
\createTheorem{definition}{%
    Definition
}{%
    \rmfamily
    \bfseries
    \boldmath
}{%
    \itshape
}

% ------------------------------------------------------------------------------
% Proofs and Claims

% Counter
\newcounter{proofLevel}
\newcounter{globalProofCounter}
\newcounter{localClaimCounter}[globalProofCounter]%
\newcounter{skipQedCounter}

% QED symbol
\DeclareRobustCommand{\qed}{%
    \def\qedChar{\square}%
    \ifnum 1 < \value{proofLevel}%
        \def\qedChar{\lozenge}%
    \fi%
    \ifmmode%
        \qedChar%
    \else%
        \leavevmode\unskip\penalty9999 \hbox{}\nobreak\hfill%
        \quad\hbox{$\qedChar$}%
    \fi%
}%

% QedHere
\newcommand{\qedhere}{%
    \tag*{\qed}%
    \addtocounter{skipQedCounter}{1}%
}

% Claim
\newcommand{\claimNo}{%
    \the\value{localClaimCounter}%
}

\newenvironment{claim*}{%
    \trivlist\item[\hskip\labelsep\textit{Claim.}\;]%
    \itshape%
}{%
    \endtrivlist
}

\newenvironment{claim}{%
    \stepcounter{localClaimCounter}%
    \setLabel{\claimNo}%
    \trivlist\item[\hskip\labelsep\textit{Claim~\claimNo.}\;]%
    \itshape%
}{%
    \endtrivlist
}

% Proof
\newenvironment{proof}[1][]{%
    \addtocounter{proofLevel}{1}%
    \ifnum \value{proofLevel} = 1%
        \stepcounter{globalProofCounter}%
    \fi%
    \ifthenelse{\equal{#1}{\empty}}{%
        \trivlist\item[\hskip\labelsep\textit{Proof.}\;]%
    }{%
        \trivlist\item[\hskip\labelsep\textit{Proof\enspace(#1).}\;]
    }%
}{%
    \ifnum \value{skipQedCounter} > 0%
        \addtocounter{skipQedCounter}{-1}%
    \fi%
    \endtrivlist%
    \addtocounter{proofLevel}{-1}%
}

% ------------------------------------------------------------------------------
% Algorithms

\usepackage[%
    resetcount,
    algochapter,
    ruled,
    vlined,
    linesnumbered,
    algo2e,
]{algorithm2e}

% Ensure `Input` and `Output` are aligned at their right side. That is:
%
%      Input: ...
%     Output: ...
%
% instead of
%
%     Input: ...
%     Output: ...
\newlength{\kwInLen}
\newlength{\kwInGap}
\SetKwInput{KwIn}{\hspace*{\kwInGap}Input}

% Define algorithm-environment
\newenvironment{algorithm}{%
    \settowidth{\kwInLen}{\KwSty{Input}}
    \settowidth{\kwInGap}{\KwSty{Output}}
    \addtolength{\kwInGap}{-\kwInLen}
    \begin{algorithm2e}%
}{%
    \end{algorithm2e}%
}

% No semicolons (;) after commands.
\DontPrintSemicolon

% General design.
\renewcommand{\KwSty}[1]{%
    \textnormal{\sffamily\sbseries{#1}}%
    \unskip%
}


% Spelling of keywords: `Do` keyword is removed and all keywords start with a
% capital letter.
\SetKw{KwTo}{To}
\SetKw{KwDownTo}{DownTo}

\SetKw{KwRet}{Return}

\SetKw{Return}{Return}

\SetKwBlock{Begin}
           {Begin}{End}

\SetKwIF{If}{ElseIf}{Else}
        {If}{Then}{Else If}{Else}{End If}

\SetKwSwitch{Switch}{Case}{Other}
            {Switch}{}{Case}{Otherwise}{End Case}{End Switch}

\SetKwFor{For}
         {For}{}{End For}

\SetKwFor{While}
         {While}{}{End While}

\SetKwFor{ForEach}
         {For Each}{}{End For}

\SetKwFor{ForAll}
         {For All}{}{End For}

\SetKwRepeat{Repeat}
            {Repeat}{Until}

% ------------------------------------------------------------------------------
% NTU Logo as TikZ picture.

\usepackage{tikz}

\definecolor{c231f20}{RGB}{35,31,32}
\definecolor{ce01932}{RGB}{224,25,50}
\definecolor{ce6ab39}{RGB}{230,171,57}
\definecolor{c638e8c}{RGB}{99,142,140}
\definecolor{c0c3c5d}{RGB}{12,60,93}
\definecolor{ce5ae4a}{RGB}{229,174,74}
\definecolor{cc08532}{RGB}{192,133,50}
\definecolor{c85b3da}{RGB}{133,179,218}
\definecolor{c162c53}{RGB}{22,44,83}
\definecolor{c5e85a9}{RGB}{94,133,169}
\definecolor{cc98e37}{RGB}{201,142,55}
\definecolor{cd39a3e}{RGB}{211,154,62}
\definecolor{cefc283}{RGB}{239,194,131}
\definecolor{ce3aa36}{RGB}{227,170,54}
\definecolor{cf9e8b6}{RGB}{249,232,182}
\definecolor{cb21f2f}{RGB}{178,31,47}
\definecolor{cba7f2c}{RGB}{186,127,44}
\definecolor{ce0bd2d}{RGB}{224,189,45}
\definecolor{cb96367}{RGB}{185,99,103}
\definecolor{c001e61}{RGB}{0,30,97}

\newcommand{\ntuLogoTikZ}{%
\def \globalscale {1.000000}
\begin{tikzpicture}[y=1mm, x=1mm, yscale=\globalscale,xscale=\globalscale, every node/.append style={scale=\globalscale}, inner sep=0pt, outer sep=0pt]
    \begin{scope}[cm={ 1.906,-0.0,-0.0,1.906,(108.2244, -213.9578)}]
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-56.7796, 165.4924)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (0.0, 36.6752).. controls 
  (0.0, 39.6695) and (3.6327, 42.5915) .. (4.8932, 42.5915).. controls (6.059, 
  42.5915) and (9.7864, 39.6695) .. (9.7864, 36.6752) -- (9.7864, 30.0) -- (0.0,
   30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-56.6453, 165.3191)}]
      \path[fill=white,nonzero rule] (0.0, 30.0) -- (0.0, 36.5281).. controls 
  (0.0, 39.4565) and (3.5528, 42.3142) .. (4.7858, 42.3142).. controls (5.9259, 
  42.3142) and (9.5713, 39.4565) .. (9.5713, 36.5281) -- (9.5713, 30.0) -- (0.0,
   30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-56.6453, 165.3191)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0) -- (9.5713, 30.0) -- (9.5713,
   33.2446) -- (8.2267, 33.2446) -- (8.2267, 33.9293) -- (6.9321, 33.9293) -- 
  (6.9321, 33.2419) -- (5.398, 33.2419) -- (5.398, 33.9293) -- (4.0926, 33.9293)
   -- (4.0926, 33.2419) -- (2.5852, 33.2419) -- (2.5852, 33.9293) -- (1.2782, 
  33.9293) -- (1.2782, 33.2409) -- (0.0, 33.2409) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.312, 160.3416)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-1.3745, 30.0) -- 
  (-1.3745, 29.3126) -- (-2.8284, 29.3126) -- (-2.8284, 30.0) -- (-4.214, 30.0) 
  -- (-4.214, 29.3126) -- (-5.6412, 29.3126) -- (-5.6412, 30.0) -- (-7.0284, 
  30.0) -- (-7.0284, 29.3116) -- (-8.2666, 29.3116) -- (-8.2666, 29.2317) -- 
  (-6.9485, 29.2317) -- (-6.9485, 29.9198) -- (-5.7214, 29.9198) -- (-5.7214, 
  29.2324) -- (-4.1339, 29.2324) -- (-4.1339, 29.9198) -- (-2.9083, 29.9198) -- 
  (-2.9083, 29.2324) -- (-1.2943, 29.2324) -- (-1.2943, 29.9198) -- (-0.0802, 
  29.9198) -- (-0.0802, 29.2351) -- (1.3047, 29.2351) -- (1.3047, 29.3153) -- 
  (0.0, 29.3153) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.2338, 164.6139)}]
      \path[fill=white,nonzero rule] (0.0, 30.0) -- (-0.0394, 30.009).. controls
   (-0.1635, 30.0802) and (-0.1074, 30.5966) .. (0.2633, 31.2435).. controls 
  (0.5842, 31.8034) and (0.9591, 32.1378) .. (1.1361, 32.1378) -- (1.1755, 
  32.1288).. controls (1.2224, 32.1019) and (1.2599, 31.9833) .. (1.2115, 
  31.7373).. controls (1.1628, 31.4899) and (1.0425, 31.1904) .. (0.8729, 
  30.8943).. controls (0.5519, 30.3344) and (0.177, 30.0) .. (0.0, 30.0)(1.1361,
   32.3249).. controls (0.8123, 32.3249) and (0.3829, 31.8285) .. (0.1011, 
  31.3367).. controls (-0.2471, 30.7292) and (-0.4389, 30.0225) .. (-0.1323, 
  29.8468).. controls (-0.0931, 29.8243) and (-0.0487, 29.8129) .. (-0.0, 
  29.8129).. controls (0.3239, 29.8129) and (0.7533, 30.3093) .. (1.0351, 
  30.8012).. controls (1.2147, 31.1147) and (1.3425, 31.4343) .. (1.3951, 
  31.7013).. controls (1.4708, 32.0857) and (1.3679, 32.2339) .. (1.2684, 
  32.291).. controls (1.2293, 32.3135) and (1.1848, 32.3249) .. (1.1361, 
  32.3249);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.5551, 163.7104)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (-0.7297, 30.0) and 
  (-1.197, 30.2032) .. (-1.198, 30.3432).. controls (-1.1983, 30.3971) and 
  (-1.1147, 30.4895) .. (-0.8779, 30.5712).. controls (-0.6395, 30.6538) and 
  (-0.3199, 30.7004) .. (0.0214, 30.7025) -- (0.0474, 30.7027).. controls 
  (0.7771, 30.7027) and (1.2443, 30.4995) .. (1.2451, 30.3596).. controls 
  (1.2457, 30.3056) and (1.1618, 30.2135) .. (0.9252, 30.1315).. controls 
  (0.6866, 30.0489) and (0.3672, 30.0024) .. (0.0259, 30.0003) -- cycle(0.0474, 
  30.8895) -- (0.0201, 30.8895).. controls (-0.3413, 30.8874) and (-0.6818, 
  30.8369) .. (-0.939, 30.748).. controls (-1.3089, 30.6202) and (-1.3856, 
  30.4567) .. (-1.3851, 30.3418).. controls (-1.3824, 29.9947) and (-0.6863, 
  29.8129) .. (0.0, 29.8129) -- (0.0273, 29.8132).. controls (0.3884, 29.8156) 
  and (0.7289, 29.8659) .. (0.9864, 29.9548).. controls (1.3563, 30.0828) and 
  (1.433, 30.2463) .. (1.4325, 30.3609).. controls (1.4298, 30.7083) and 
  (0.7337, 30.8895) .. (0.0474, 30.8895);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.7997, 164.6199)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (-0.1773, 30.0) and 
  (-0.5522, 30.3347) .. (-0.8729, 30.8943).. controls (-1.0425, 31.1904) and 
  (-1.1631, 31.4901) .. (-1.2115, 31.7375).. controls (-1.2599, 31.9836) and 
  (-1.2224, 32.1019) .. (-1.1755, 32.1288) -- (-1.1361, 32.1381).. controls 
  (-0.9591, 32.1381) and (-0.5842, 31.8034) .. (-0.2635, 31.2435).. controls 
  (0.1074, 30.5966) and (0.1635, 30.0804) .. (0.0392, 30.009) -- (0.0, 
  30.0)(-1.1361, 32.3252).. controls (-1.1851, 32.3252) and (-1.2293, 32.3138) 
  .. (-1.2687, 32.291).. controls (-1.3682, 32.2341) and (-1.4708, 32.0854) .. 
  (-1.3951, 31.7015).. controls (-1.3428, 31.4343) and (-1.2147, 31.115) .. 
  (-1.0353, 30.8012).. controls (-0.7533, 30.3093) and (-0.3239, 29.8129) .. 
  (0.0, 29.8129).. controls (0.0487, 29.8129) and (0.0931, 29.8243) .. (0.1323, 
  29.8468).. controls (0.4389, 30.0225) and (0.2471, 30.7295) .. (-0.1011, 
  31.3367).. controls (-0.3831, 31.8285) and (-0.8123, 32.3252) .. (-1.1361, 
  32.3252);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.2298, 161.6747)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0365, 30.0) 
  and (-0.0733, 29.9944) .. (-0.1082, 29.9804).. controls (-0.2096, 29.9402) and
   (-0.2765, 29.8413) .. (-0.3072, 29.6865).. controls (-0.3085, 29.6772) and 
  (-0.3352, 29.4904) .. (-0.2434, 29.1663) -- (-0.235, 29.1364) -- (0.0167, 
  29.1867) -- (0.0061, 29.2219).. controls (0.0056, 29.2237) and (-0.0519, 
  29.4169) .. (-0.0556, 29.5333).. controls (-0.0601, 29.5952) and (-0.0553, 
  29.7031) .. (-0.0212, 29.7381) -- (0.0034, 29.7479) -- (0.0066, 29.7476) -- 
  (0.0098, 29.7481) -- (0.0106, 29.7481).. controls (0.0188, 29.7481) and 
  (0.0939, 29.7452) .. (0.2432, 29.6296).. controls (0.2447, 29.6283) and 
  (0.4638, 29.4486) .. (0.6056, 29.2422).. controls (0.6088, 29.2377) and 
  (0.8281, 28.9507) .. (0.9366, 28.7091).. controls (0.9403, 28.7025) and 
  (1.1499, 28.3307) .. (1.2012, 27.9304).. controls (1.2129, 27.855) and 
  (1.2142, 27.7235) .. (1.1687, 27.6865).. controls (1.1628, 27.6815) and 
  (1.1451, 27.6672) .. (1.0975, 27.6849).. controls (1.0933, 27.6862) and 
  (0.8446, 27.768) .. (0.5265, 28.2074).. controls (0.5247, 28.2101) and 
  (0.3283, 28.4861) .. (0.1974, 28.7438) -- (0.1376, 28.7136).. controls 
  (0.2709, 28.4511) and (0.4702, 28.1712) .. (0.4723, 28.1686).. controls 
  (0.8054, 27.7079) and (1.0652, 27.6248) .. (1.0761, 27.6214).. controls 
  (1.1433, 27.5965) and (1.1867, 27.6145) .. (1.211, 27.6346).. controls 
  (1.3007, 27.7077) and (1.2711, 27.9161) .. (1.2674, 27.9397).. controls 
  (1.2144, 28.3524) and (1.0052, 28.7237) .. (0.9962, 28.7393).. controls 
  (0.8861, 28.9853) and (0.6689, 29.2692) .. (0.6596, 29.2814).. controls 
  (0.5136, 29.4944) and (0.2942, 29.6743) .. (0.285, 29.6817).. controls 
  (0.1162, 29.8124) and (0.0257, 29.8166) .. (0.004, 29.8145).. controls 
  (-0.0241, 29.8156) and (-0.0495, 29.805) .. (-0.0693, 29.7844).. controls 
  (-0.1349, 29.7166) and (-0.1236, 29.5486) .. (-0.122, 29.5298).. controls 
  (-0.1193, 29.4362) and (-0.0852, 29.3012) .. (-0.068, 29.238) -- (-0.1873, 
  29.2139).. controls (-0.2654, 29.5063) and (-0.2416, 29.6735) .. (-0.2413, 
  29.6748).. controls (-0.2156, 29.8047) and (-0.1625, 29.887) .. (-0.0836, 
  29.9182).. controls (0.0749, 29.9812) and (0.2924, 29.8272) .. (0.2945, 
  29.8254).. controls (0.5398, 29.6666) and (0.8422, 29.2393) .. (0.8451, 
  29.2348).. controls (1.1367, 28.8424) and (1.3195, 28.2736) .. (1.3213, 
  28.2678).. controls (1.384, 28.059) and (1.3922, 27.8894) .. (1.3922, 
  27.8878).. controls (1.4002, 27.7296) and (1.3679, 27.6161) .. (1.2965, 
  27.5508).. controls (1.2144, 27.4759) and (1.1081, 27.4896) .. (1.1073, 
  27.4899).. controls (0.6395, 27.55) and (0.099, 28.5308) .. (0.0934, 28.5406) 
  -- (0.0349, 28.5085).. controls (0.0577, 28.4673) and (0.5974, 27.488) .. 
  (1.0983, 27.4238).. controls (1.1036, 27.423) and (1.2369, 27.4058) .. 
  (1.3414, 27.5015).. controls (1.4282, 27.5809) and (1.4679, 27.7119) .. 
  (1.4589, 27.8907).. controls (1.4586, 27.8979) and (1.4504, 28.0699) .. 
  (1.3851, 28.2874).. controls (1.383, 28.294) and (1.197, 28.8734) .. (0.8993, 
  29.274).. controls (0.8871, 29.2912) and (0.5871, 29.7158) .. (0.3321, 
  29.8807).. controls (0.3249, 29.8857) and (0.1635, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.0584, 163.2533)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.172, 29.6418) 
  and (-0.3953, 29.3888) .. (-0.3974, 29.3864) -- (-0.3477, 29.342).. controls 
  (-0.3381, 29.3526) and (-0.1162, 29.6039) .. (0.0601, 29.9712) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.9287, 163.5189)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.155, 29.7111) 
  and (-0.3757, 29.4558) .. (-0.3778, 29.4534) -- (-0.3276, 29.4095).. controls 
  (-0.3252, 29.4121) and (-0.0995, 29.673) .. (0.0587, 29.9683) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.1071, 162.8472)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.1683, 29.6759).. 
  controls (-0.6234, 28.6623) and (-0.3392, 28.4575) .. (-0.3, 28.4353).. 
  controls (0.0347, 28.1831) and (0.4736, 28.7083) .. (0.4924, 28.7308) -- 
  (0.4408, 28.7731).. controls (0.4366, 28.7684) and (0.0228, 28.2728) .. 
  (-0.2617, 28.4898) -- (-0.2675, 28.4935).. controls (-0.2699, 28.4948) and 
  (-0.5517, 28.6588) .. (-0.1082, 29.647) -- (0.0593, 29.9693) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.7998, 162.8029)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.6146, 29.1007)
   and (-0.4744, 28.6321) .. (-0.4683, 28.6125).. controls (-0.4382, 28.5456) 
  and (-0.3924, 28.5265) .. (-0.359, 28.5212).. controls (-0.182, 28.4951) and 
  (0.0939, 28.8014) .. (0.1246, 28.8366) -- (0.0746, 28.8808).. controls 
  (-0.0029, 28.793) and (-0.2299, 28.5707) .. (-0.3493, 28.5874).. controls 
  (-0.3651, 28.59) and (-0.3884, 28.5977) .. (-0.4061, 28.6366).. controls 
  (-0.4059, 28.6377) and (-0.5382, 29.0941) .. (0.0553, 29.9624) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.8037, 161.6592)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1585, 30.0) 
  and (-0.3596, 29.8804) .. (-0.5998, 29.6428) -- (-0.5527, 29.5955).. controls 
  (-0.2199, 29.9246) and (-0.0328, 29.9553) .. (0.0661, 29.9233).. controls 
  (0.2016, 29.8791) and (0.2328, 29.6978) .. (0.2331, 29.6957).. controls 
  (0.3151, 29.4137) and (0.009, 28.7308) .. (0.0058, 28.7242) -- (0.0667, 
  28.6967).. controls (0.0796, 28.7258) and (0.386, 29.4089) .. (0.2982, 
  29.7103).. controls (0.2979, 29.7153) and (0.2617, 29.9294) .. (0.087, 
  29.9865).. controls (0.0598, 29.9955) and (0.0307, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.8275, 161.9026)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1064, 30.0003)
   and (-0.2596, 29.8984) .. (-0.4569, 29.6968) -- (-0.4093, 29.65).. controls 
  (-0.1066, 29.9593) and (0.0042, 29.9397) .. (0.0312, 29.927).. controls 
  (0.0746, 29.9053) and (0.0892, 29.8206) .. (0.0712, 29.6944).. controls 
  (0.0225, 29.3534) and (-0.0863, 29.1502) .. (-0.0873, 29.148) -- (-0.0286, 
  29.116).. controls (-0.0241, 29.1248) and (0.087, 29.3322) .. (0.1373, 
  29.6849).. controls (0.1606, 29.8484) and (0.1349, 29.9503) .. (0.0609, 
  29.9868) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.7036, 162.2836)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0445, 29.959) 
  and (-0.1707, 29.7727) .. (-0.1847, 29.7516) -- (-0.1294, 29.714).. controls 
  (-0.0751, 29.7947) and (0.0159, 29.9238) .. (0.0452, 29.9505) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.3786, 162.9223)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0656, 29.9865).. 
  controls (-0.0598, 29.9577) and (0.0228, 29.7653) .. (0.0479, 29.7074) -- 
  (0.1093, 29.7338).. controls (0.0587, 29.8505) and (0.0042, 29.982) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.9638, 162.825)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0074, 29.9336) -- 
  (0.0863, 29.923) -- (0.0937, 29.9894) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.1149, 162.5631)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0341, 30.0) 
  and (-0.0392, 29.9934) .. (-0.0455, 29.9852) -- (0.0071, 29.9442) -- (-0.0098,
   29.9333).. controls (0.0122, 29.9365) and (0.149, 29.9182) .. (0.2691, 
  29.8997) -- (0.2794, 29.9656).. controls (0.1172, 29.9913) and (0.0394, 30.0) 
  .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.4602, 162.5565)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1101, 30.0) 
  and (-0.6813, 29.9929) .. (-1.0395, 29.8524).. controls (-1.2306, 29.7772) and
   (-1.4642, 29.6486) .. (-1.4917, 29.461).. controls (-1.5089, 29.343) and 
  (-1.4417, 29.224) .. (-1.292, 29.1065).. controls (-1.2838, 29.1007) and 
  (-1.115, 28.9814) .. (-0.8408, 28.9274) -- (-0.8281, 28.993).. controls 
  (-1.0869, 29.0441) and (-1.2504, 29.1586) .. (-1.252, 29.1597).. controls 
  (-1.3803, 29.2605) and (-1.4391, 29.3587) .. (-1.4256, 29.4513).. controls 
  (-1.4078, 29.5732) and (-1.2621, 29.6933) .. (-1.0152, 29.7902).. controls 
  (-0.6376, 29.9384) and (0.0106, 29.9331) .. (0.0169, 29.9331) -- (0.0177, 
  30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.484, 162.784)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.4868, 30.0) 
  and (-1.0869, 29.877) .. (-1.2525, 29.6833).. controls (-1.2943, 29.6346) and 
  (-1.2914, 29.5902) .. (-1.2816, 29.5619).. controls (-1.2282, 29.4039) and 
  (-0.8059, 29.3102) .. (-0.7583, 29.2999) -- (-0.7443, 29.3655).. controls 
  (-0.911, 29.4007) and (-1.1872, 29.4912) .. (-1.2184, 29.5833).. controls 
  (-1.2224, 29.5949) and (-1.2248, 29.6129) .. (-1.2017, 29.6399).. controls 
  (-1.0464, 29.8217) and (-0.3686, 29.9643) .. (0.1672, 29.9278) -- (0.1717, 
  29.9944).. controls (0.1169, 29.9979) and (0.0593, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.2109, 163.6184)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0111, 29.9341).. 
  controls (0.0675, 29.9209) and (0.1146, 29.9151) .. (0.1278, 29.9167) -- 
  (0.1196, 29.9831) -- (0.1193, 29.9831).. controls (0.109, 29.9831) and 
  (0.0492, 29.9918) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.2897, 163.8519)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0101, 29.9341).. 
  controls (-0.0003, 29.9323) and (0.2305, 29.8965) .. (0.3204, 29.8958) -- 
  (0.3209, 29.9627).. controls (0.2357, 29.9635) and (0.0024, 29.9997) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.1451, 162.87)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0614, 29.9738) -- 
  (-0.0243, 29.8865) -- (0.037, 29.9124) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.274, 163.6571)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0415, 29.9881)
   and (-0.2606, 29.9899) .. (-0.3895, 29.9939) -- (-0.3913, 29.927).. controls 
  (-0.3564, 29.9259) and (-0.0468, 29.9172) .. (0.0183, 29.936) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.6044, 163.8982)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0013, 29.9333) -- 
  (0.1323, 29.9302) -- (0.1336, 29.9971) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.7802, 163.8341)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1365, 29.9643)
   and (-0.2768, 29.9664) .. (-0.2802, 29.9643) -- (-0.2805, 29.8976).. controls
   (-0.2738, 29.8971) and (-0.1283, 29.8976) .. (0.0167, 29.9352) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.855, 163.6108)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.1135, 29.9762) -- 
  (-0.0997, 29.9106) -- (0.0138, 29.9346) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.6099, 162.8796)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0146, 29.9349).. 
  controls (0.3125, 29.8614) and (0.4053, 29.7621) .. (0.4061, 29.7616) -- 
  (0.4096, 29.7582).. controls (0.4561, 29.7187) and (0.4498, 29.6931) .. 
  (0.4477, 29.6846).. controls (0.4249, 29.5902) and (0.1519, 29.4933) .. 
  (-0.0148, 29.4542) -- (0.0003, 29.3891).. controls (0.0487, 29.4005) and 
  (0.4731, 29.5044) .. (0.5128, 29.6687).. controls (0.5207, 29.7023) and 
  (0.5173, 29.7537) .. (0.4543, 29.8076).. controls (0.4382, 29.8248) and 
  (0.3297, 29.9262) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.516, 162.6494)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0116, 29.9344).. 
  controls (-0.0056, 29.9331) and (0.59, 29.8241) .. (0.5649, 29.5134).. 
  controls (0.5395, 29.198) and (-0.0183, 29.0914) .. (-0.0238, 29.0906) -- 
  (-0.0119, 29.0247).. controls (0.0132, 29.0295) and (0.6019, 29.1417) .. 
  (0.6316, 29.5081).. controls (0.6615, 29.8791) and (0.027, 29.9952) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.2563, 164.1761)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0955) and 
  (-0.0778, 30.1733) .. (-0.1736, 30.1733).. controls (-0.2693, 30.1733) and 
  (-0.3469, 30.0955) .. (-0.3469, 30.0).. controls (-0.3469, 29.904) and 
  (-0.2693, 29.8264) .. (-0.1736, 29.8264).. controls (-0.0778, 29.8264) and 
  (0.0, 29.904) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.4729, 164.351)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0773, 30.0) 
  and (-0.1402, 30.0624) .. (-0.1402, 30.14).. controls (-0.1402, 30.217) and 
  (-0.0773, 30.2802) .. (0.0, 30.2802).. controls (0.0773, 30.2802) and (0.1402,
   30.217) .. (0.1402, 30.14).. controls (0.1402, 30.0624) and (0.0773, 30.0) ..
   (0.0, 30.0)(0.0, 30.3466).. controls (-0.1143, 30.3466) and (-0.2069, 30.254)
   .. (-0.2069, 30.14).. controls (-0.2069, 30.0259) and (-0.1143, 29.9328) .. 
  (0.0, 29.9328).. controls (0.114, 29.9328) and (0.2069, 30.0259) .. (0.2069, 
  30.14).. controls (0.2069, 30.254) and (0.114, 30.3466) .. (0.0, 30.3466);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.2932, 163.2589)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0958) and 
  (-0.0778, 30.1733) .. (-0.1736, 30.1733).. controls (-0.2693, 30.1733) and 
  (-0.3471, 30.0958) .. (-0.3471, 30.0).. controls (-0.3471, 29.9042) and 
  (-0.2693, 29.8264) .. (-0.1736, 29.8264).. controls (-0.0778, 29.8264) and 
  (0.0, 29.9042) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.5101, 163.4346)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0773, 30.0) 
  and (-0.14, 30.063) .. (-0.14, 30.1402).. controls (-0.14, 30.2175) and 
  (-0.0773, 30.2805) .. (0.0, 30.2805).. controls (0.0773, 30.2805) and (0.1402,
   30.2175) .. (0.1402, 30.1402).. controls (0.1402, 30.063) and (0.0773, 30.0) 
  .. (0.0, 30.0)(0.0, 30.3471).. controls (-0.114, 30.3471) and (-0.2069, 
  30.2545) .. (-0.2069, 30.1402).. controls (-0.2069, 30.0262) and (-0.114, 
  29.9333) .. (0.0, 29.9333).. controls (0.114, 29.9333) and (0.2069, 30.0262) 
  .. (0.2069, 30.1402).. controls (0.2069, 30.2545) and (0.114, 30.3471) .. 
  (0.0, 30.3471);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.6719, 161.9972)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.096) and 
  (-0.0778, 30.1736) .. (-0.1736, 30.1736).. controls (-0.2693, 30.1736) and 
  (-0.3471, 30.096) .. (-0.3471, 30.0).. controls (-0.3471, 29.9045) and 
  (-0.2693, 29.8267) .. (-0.1736, 29.8267).. controls (-0.0778, 29.8267) and 
  (0.0, 29.9045) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.8888, 162.1722)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0773, 30.0) 
  and (-0.14, 30.0627) .. (-0.14, 30.14).. controls (-0.14, 30.2172) and 
  (-0.0773, 30.2799) .. (0.0, 30.2799).. controls (0.0773, 30.2799) and (0.1402,
   30.2172) .. (0.1402, 30.14).. controls (0.1402, 30.0627) and (0.0773, 30.0) 
  .. (0.0, 30.0)(0.0, 30.3471).. controls (-0.114, 30.3471) and (-0.2069, 
  30.2543) .. (-0.2069, 30.14).. controls (-0.2069, 30.0259) and (-0.114, 
  29.9333) .. (0.0, 29.9333).. controls (0.1143, 29.9333) and (0.2069, 30.0259) 
  .. (0.2069, 30.14).. controls (0.2069, 30.2543) and (0.1143, 30.3471) .. (0.0,
   30.3471);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.9355, 162.9408)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0955) and 
  (-0.0778, 30.1733) .. (-0.1736, 30.1733).. controls (-0.2693, 30.1733) and 
  (-0.3469, 30.0955) .. (-0.3469, 30.0).. controls (-0.3469, 29.904) and 
  (-0.2693, 29.8264) .. (-0.1736, 29.8264).. controls (-0.0778, 29.8264) and 
  (0.0, 29.904) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.1525, 163.1164)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.077, 30.0) and
   (-0.14, 30.0627) .. (-0.14, 30.14).. controls (-0.14, 30.2172) and (-0.077, 
  30.2802) .. (0.0, 30.2802).. controls (0.0773, 30.2802) and (0.1402, 30.2172) 
  .. (0.1402, 30.14).. controls (0.1402, 30.0627) and (0.0773, 30.0) .. (0.0, 
  30.0)(0.0, 30.3469).. controls (-0.114, 30.3469) and (-0.2069, 30.2543) .. 
  (-0.2069, 30.14).. controls (-0.2069, 30.0262) and (-0.114, 29.9331) .. (0.0, 
  29.9331).. controls (0.1143, 29.9331) and (0.2069, 30.0262) .. (0.2069, 
  30.14).. controls (0.2069, 30.2543) and (0.1143, 30.3469) .. (0.0, 30.3469);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5549, 164.6067)}]
      \path[fill=white,nonzero rule] (0.0, 30.0) -- (-0.0394, 30.009).. controls
   (-0.0863, 30.0357) and (-0.1238, 30.1545) .. (-0.0754, 30.4003).. controls 
  (-0.0267, 30.6477) and (0.0937, 30.9472) .. (0.2633, 31.2433).. controls 
  (0.5842, 31.8034) and (0.9589, 32.1378) .. (1.1361, 32.1378) -- (1.1755, 
  32.1286).. controls (1.2224, 32.1016) and (1.2599, 31.9833) .. (1.2115, 
  31.7373).. controls (1.1628, 31.4899) and (1.0425, 31.1901) .. (0.8729, 
  30.894).. controls (0.5519, 30.3344) and (0.177, 30.0) .. (0.0, 30.0)(1.1361, 
  32.3249).. controls (0.8123, 32.3249) and (0.3831, 31.8283) .. (0.1011, 
  31.3364).. controls (-0.0786, 31.0231) and (-0.2064, 30.7033) .. (-0.259, 
  30.4363).. controls (-0.3344, 30.0521) and (-0.2318, 29.9037) .. (-0.1323, 
  29.8465).. controls (-0.0931, 29.8243) and (-0.0487, 29.8129) .. (-0.0, 
  29.8129).. controls (0.3239, 29.8129) and (0.7533, 30.309) .. (1.0351, 
  30.8009).. controls (1.2147, 31.1147) and (1.3425, 31.434) .. (1.3951, 
  31.7013).. controls (1.4706, 32.0854) and (1.3679, 32.2339) .. (1.2684, 
  32.2908).. controls (1.2293, 32.3135) and (1.1848, 32.3249) .. (1.1361, 
  32.3249);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.8762, 163.7034)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (-0.7297, 30.0) and 
  (-1.197, 30.2032) .. (-1.1978, 30.3429).. controls (-1.1983, 30.3971) and 
  (-1.1147, 30.4892) .. (-0.8776, 30.5712).. controls (-0.6392, 30.6535) and 
  (-0.3199, 30.7001) .. (0.0214, 30.7025) -- (0.0476, 30.7025).. controls 
  (0.7773, 30.7025) and (1.2443, 30.4995) .. (1.2454, 30.3593).. controls 
  (1.2462, 30.2162) and (0.7718, 30.0048) .. (0.0259, 30.0) -- cycle(0.0476, 
  30.8895) -- (0.0201, 30.8895).. controls (-0.3413, 30.8871) and (-0.6818, 
  30.8369) .. (-0.939, 30.748).. controls (-1.3089, 30.6202) and (-1.3856, 
  30.4567) .. (-1.3848, 30.3418).. controls (-1.3827, 29.9944) and (-0.6866, 
  29.8129) .. (0.0, 29.8129) -- (0.0273, 29.8129).. controls (0.7273, 29.8177) 
  and (1.4346, 30.0074) .. (1.4325, 30.3606).. controls (1.4301, 30.708) and 
  (0.734, 30.8895) .. (0.0476, 30.8895);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.1209, 164.6129)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (-0.1773, 30.0) and 
  (-0.5522, 30.3347) .. (-0.8731, 30.8943).. controls (-1.2435, 31.5412) and 
  (-1.2996, 32.0574) .. (-1.1755, 32.1288) -- (-1.1364, 32.1378).. controls 
  (-0.9591, 32.1378) and (-0.5842, 31.8031) .. (-0.2635, 31.2435).. controls 
  (0.1074, 30.5966) and (0.1632, 30.0804) .. (0.0392, 30.009) -- (0.0, 
  30.0)(-1.1364, 32.3249).. controls (-1.1848, 32.3249) and (-1.2295, 32.3135) 
  .. (-1.2687, 32.291).. controls (-1.5753, 32.1153) and (-1.3832, 31.4086) .. 
  (-1.0353, 30.8012).. controls (-0.7533, 30.3093) and (-0.3239, 29.8129) .. 
  (0.0, 29.8129).. controls (0.0484, 29.8129) and (0.0931, 29.8243) .. (0.1323, 
  29.8468).. controls (0.4387, 30.0225) and (0.2469, 30.7295) .. (-0.1011, 
  31.3367).. controls (-0.3831, 31.8285) and (-0.8123, 32.3249) .. (-1.1364, 
  32.3249);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5506, 161.6681)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0365, 30.0) 
  and (-0.0733, 29.9944) .. (-0.1082, 29.9807).. controls (-0.2096, 29.9402) and
   (-0.2765, 29.8415) .. (-0.3072, 29.6865).. controls (-0.3085, 29.6772) and 
  (-0.3352, 29.4907) .. (-0.2434, 29.1663) -- (-0.235, 29.1364) -- (0.0167, 
  29.1869) -- (0.0061, 29.2219).. controls (0.0056, 29.224) and (-0.0519, 
  29.4171) .. (-0.0556, 29.5335).. controls (-0.0603, 29.5952) and (-0.055, 
  29.7031) .. (-0.0212, 29.7383) -- (0.0034, 29.7481) -- (0.0066, 29.7479) -- 
  (0.0098, 29.7484).. controls (0.0114, 29.7484) and (0.0855, 29.7518) .. 
  (0.2434, 29.6298).. controls (0.245, 29.6285) and (0.4638, 29.4489) .. 
  (0.6056, 29.2422).. controls (0.6088, 29.238) and (0.8281, 28.9509) .. 
  (0.9366, 28.7094).. controls (0.9403, 28.7027) and (1.1499, 28.3307) .. 
  (1.2012, 27.9307).. controls (1.2129, 27.855) and (1.2142, 27.7235) .. 
  (1.1687, 27.6865).. controls (1.1628, 27.6817) and (1.1449, 27.6674) .. 
  (1.0975, 27.6849).. controls (1.0933, 27.6862) and (0.8443, 27.7682) .. 
  (0.5265, 28.2077).. controls (0.5247, 28.2101) and (0.3283, 28.4861) .. 
  (0.1974, 28.744) -- (0.1378, 28.7139).. controls (0.2709, 28.4514) and 
  (0.4704, 28.1715) .. (0.4723, 28.1688).. controls (0.8054, 27.7082) and 
  (1.0652, 27.6248) .. (1.0761, 27.6217).. controls (1.143, 27.5968) and 
  (1.1867, 27.6148) .. (1.211, 27.6346).. controls (1.3007, 27.7079) and 
  (1.2711, 27.9164) .. (1.2674, 27.94).. controls (1.2142, 28.3527) and (1.0052,
   28.7239) .. (0.9962, 28.7393).. controls (0.8858, 28.9853) and (0.6686, 
  29.2695) .. (0.6596, 29.2817).. controls (0.5136, 29.4946) and (0.2942, 
  29.6743) .. (0.285, 29.682).. controls (0.1162, 29.8127) and (0.0249, 29.8169)
   .. (0.0042, 29.8148).. controls (-0.0254, 29.8161) and (-0.0495, 29.8053) .. 
  (-0.0691, 29.7849).. controls (-0.1349, 29.7166) and (-0.1236, 29.5489) .. 
  (-0.122, 29.5301).. controls (-0.1193, 29.4362) and (-0.0852, 29.3015) .. 
  (-0.068, 29.238) -- (-0.1873, 29.2142).. controls (-0.2654, 29.5063) and 
  (-0.2416, 29.6738) .. (-0.2413, 29.6751).. controls (-0.2156, 29.805) and 
  (-0.1625, 29.887) .. (-0.0836, 29.9182).. controls (0.0746, 29.9812) and 
  (0.2924, 29.8272) .. (0.2945, 29.8256).. controls (0.5398, 29.6666) and 
  (0.8422, 29.2393) .. (0.8451, 29.2348).. controls (1.1367, 28.8427) and 
  (1.3195, 28.2739) .. (1.3213, 28.268).. controls (1.384, 28.0588) and (1.392, 
  27.8894) .. (1.392, 27.8878).. controls (1.3999, 27.7296) and (1.3676, 
  27.6164) .. (1.2962, 27.5508).. controls (1.2144, 27.4759) and (1.1081, 
  27.4899) .. (1.1073, 27.4902).. controls (0.6392, 27.5502) and (0.0992, 
  28.531) .. (0.0937, 28.5408) -- (0.0349, 28.5088).. controls (0.0577, 28.4673)
   and (0.5972, 27.4883) .. (1.0983, 27.4238).. controls (1.1036, 27.4232) and 
  (1.2367, 27.4058) .. (1.3414, 27.5018).. controls (1.4282, 27.5812) and 
  (1.4676, 27.7119) .. (1.4589, 27.8907).. controls (1.4586, 27.8982) and 
  (1.4504, 28.0701) .. (1.3851, 28.2876).. controls (1.3832, 28.294) and (1.197,
   28.8734) .. (0.8991, 29.2742).. controls (0.8871, 29.2914) and (0.5871, 
  29.7161) .. (0.3321, 29.8809).. controls (0.3249, 29.886) and (0.1635, 30.0) 
  .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.3791, 163.2464)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1722, 29.6418)
   and (-0.3953, 29.3891) .. (-0.3974, 29.3867) -- (-0.3474, 29.3422).. controls
   (-0.3381, 29.3526) and (-0.1162, 29.6042) .. (0.0601, 29.9712) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.2495, 163.5123)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.155, 29.7116) 
  and (-0.3757, 29.456) .. (-0.3781, 29.4536) -- (-0.3276, 29.4097).. controls 
  (-0.3252, 29.4121) and (-0.0997, 29.6732) .. (0.0587, 29.9685) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.4279, 162.8402)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.1685, 29.6759).. 
  controls (-0.6236, 28.662) and (-0.3395, 28.4575) .. (-0.3003, 28.4353).. 
  controls (0.0347, 28.1828) and (0.4736, 28.708) .. (0.4921, 28.7308) -- 
  (0.4405, 28.7731).. controls (0.4366, 28.7684) and (0.0222, 28.2728) .. 
  (-0.2617, 28.4898) -- (-0.2678, 28.4935).. controls (-0.2699, 28.4948) and 
  (-0.5519, 28.6586) .. (-0.1085, 29.647) -- (0.0593, 29.9693) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.121, 162.7959)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.6146, 29.1007)
   and (-0.4744, 28.6318) .. (-0.4683, 28.6125).. controls (-0.4382, 28.5456) 
  and (-0.3924, 28.5265) .. (-0.359, 28.5212).. controls (-0.1823, 28.4956) and 
  (0.0939, 28.8014) .. (0.1249, 28.8366) -- (0.0746, 28.8808).. controls 
  (-0.0029, 28.7932) and (-0.2289, 28.5705) .. (-0.3493, 28.5874).. controls 
  (-0.3651, 28.59) and (-0.3881, 28.5974) .. (-0.4061, 28.6366).. controls 
  (-0.4059, 28.6374) and (-0.5382, 29.0938) .. (0.0553, 29.9622) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.1245, 161.6523)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1585, 30.0) 
  and (-0.3598, 29.8804) .. (-0.5998, 29.6428) -- (-0.5527, 29.5955).. controls 
  (-0.2199, 29.9246) and (-0.0325, 29.9553) .. (0.0661, 29.923).. controls 
  (0.2024, 29.8786) and (0.2328, 29.6976) .. (0.2331, 29.6957).. controls 
  (0.3149, 29.4134) and (0.0087, 28.7308) .. (0.0056, 28.7242) -- (0.0667, 
  28.6967).. controls (0.0796, 28.7258) and (0.386, 29.4089) .. (0.2982, 
  29.71).. controls (0.2977, 29.7153) and (0.2617, 29.9294) .. (0.087, 
  29.9865).. controls (0.0595, 29.9952) and (0.0304, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.1483, 161.8953)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1064, 30.0) 
  and (-0.2596, 29.8984) .. (-0.4572, 29.6963) -- (-0.4096, 29.65).. controls 
  (-0.1069, 29.959) and (0.0042, 29.9397) .. (0.031, 29.9267).. controls 
  (0.0746, 29.9053) and (0.0892, 29.8203) .. (0.0712, 29.6944).. controls 
  (0.0225, 29.3542) and (-0.0863, 29.1499) .. (-0.0873, 29.148) -- (-0.0288, 
  29.116).. controls (-0.0241, 29.1248) and (0.0868, 29.3322) .. (0.1373, 
  29.6849).. controls (0.1606, 29.8484) and (0.1349, 29.9497) .. (0.0606, 
  29.9865) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.0247, 162.277)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0445, 29.9593)
   and (-0.1707, 29.773) .. (-0.1847, 29.7518) -- (-0.1294, 29.7143).. controls 
  (-0.0751, 29.7947) and (0.0159, 29.9241) .. (0.0452, 29.9511) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.6998, 162.9153)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0654, 29.9868).. 
  controls (-0.0595, 29.9577) and (0.023, 29.7656) .. (0.0482, 29.7079) -- 
  (0.1093, 29.7341).. controls (0.059, 29.8508) and (0.0042, 29.9823) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.2846, 162.8181)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0077, 29.9339) -- 
  (0.086, 29.9233) -- (0.0937, 29.9897) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.436, 162.5558)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0341, 30.0) 
  and (-0.0392, 29.9934) .. (-0.0455, 29.9849) -- (0.0071, 29.9442) -- (-0.0098,
   29.9331).. controls (0.0124, 29.9365) and (0.1492, 29.9182) .. (0.2691, 
  29.8997) -- (0.2794, 29.9656).. controls (0.1172, 29.9913) and (0.0394, 30.0) 
  .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.7813, 162.5495)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1098, 30.0) 
  and (-0.681, 29.9929) .. (-1.0395, 29.8521).. controls (-1.2306, 29.7772) and 
  (-1.4639, 29.6486) .. (-1.4915, 29.461).. controls (-1.5087, 29.343) and 
  (-1.4417, 29.2237) .. (-1.292, 29.1062).. controls (-1.2838, 29.1004) and 
  (-1.115, 28.9811) .. (-0.8408, 28.9274) -- (-0.8279, 28.993).. controls 
  (-1.088, 29.0441) and (-1.2502, 29.1586) .. (-1.2517, 29.1597).. controls 
  (-1.3803, 29.2605) and (-1.4388, 29.3587) .. (-1.4256, 29.4513).. controls 
  (-1.4076, 29.573) and (-1.2618, 29.6933) .. (-1.0152, 29.7902).. controls 
  (-0.6376, 29.9381) and (0.0111, 29.9331) .. (0.0175, 29.9328) -- (0.018, 
  29.9997) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.8051, 162.7771)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.4868, 30.0) 
  and (-1.0869, 29.877) .. (-1.2525, 29.6836).. controls (-1.2943, 29.6349) and 
  (-1.2914, 29.5904) .. (-1.2816, 29.5621).. controls (-1.2282, 29.4042) and 
  (-0.8059, 29.3102) .. (-0.758, 29.2999) -- (-0.7443, 29.3655).. controls 
  (-0.911, 29.4007) and (-1.1872, 29.4912) .. (-1.2184, 29.5833).. controls 
  (-1.2224, 29.5949) and (-1.2248, 29.6132) .. (-1.2017, 29.6402).. controls 
  (-1.0464, 29.8217) and (-0.3683, 29.964) .. (0.1672, 29.928) -- (0.1717, 
  29.9944).. controls (0.1169, 29.9981) and (0.0593, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5317, 163.6115)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0111, 29.9339).. 
  controls (0.0675, 29.9209) and (0.1143, 29.9148) .. (0.1275, 29.9167) -- 
  (0.1196, 29.9828).. controls (0.1106, 29.9833) and (0.0495, 29.9918) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.6108, 163.8453)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0103, 29.9341).. 
  controls (-0.0005, 29.9325) and (0.2305, 29.8965) .. (0.3204, 29.896) -- 
  (0.3209, 29.963).. controls (0.2357, 29.9635) and (0.0024, 29.9997) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.4659, 162.8631)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0614, 29.9738) -- 
  (-0.0246, 29.8862) -- (0.037, 29.9124) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.5951, 163.6502)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0415, 29.9881)
   and (-0.2606, 29.9897) .. (-0.3892, 29.9937) -- (-0.3913, 29.9267).. controls
   (-0.3561, 29.9257) and (-0.0466, 29.9172) .. (0.0183, 29.9357) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.9255, 163.891)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0013, 29.9331) -- 
  (0.1323, 29.9302) -- (0.1339, 29.9971) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.1013, 163.8275)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1352, 29.9648)
   and (-0.2757, 29.9645) .. (-0.2799, 29.9645) -- (-0.2802, 29.9645) -- 
  (-0.2805, 29.8976).. controls (-0.2736, 29.8968) and (-0.1281, 29.8976) .. 
  (0.0167, 29.9352) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.1761, 163.6036)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.1132, 29.9759) -- 
  (-0.0997, 29.9106) -- (0.014, 29.9346) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-45.9307, 162.8723)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0148, 29.9349).. 
  controls (0.3125, 29.8614) and (0.4053, 29.7621) .. (0.4061, 29.7613) -- 
  (0.4096, 29.7582).. controls (0.4559, 29.7185) and (0.4498, 29.6931) .. 
  (0.4477, 29.6846).. controls (0.4247, 29.5902) and (0.1519, 29.4931) .. 
  (-0.0151, 29.4542) -- (0.0, 29.3891).. controls (0.0484, 29.4005) and (0.4728,
   29.5042) .. (0.5125, 29.6687).. controls (0.5207, 29.7023) and (0.517, 
  29.7537) .. (0.4543, 29.8076).. controls (0.4379, 29.8248) and (0.3297, 
  29.9262) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-45.8368, 162.6425)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0116, 29.9341).. 
  controls (-0.0058, 29.9331) and (0.59, 29.8241) .. (0.5649, 29.5132).. 
  controls (0.5395, 29.198) and (-0.0185, 29.0914) .. (-0.0241, 29.0904) -- 
  (-0.0119, 29.0247).. controls (0.013, 29.0292) and (0.6019, 29.1417) .. 
  (0.6316, 29.5081).. controls (0.6615, 29.8791) and (0.027, 29.995) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5771, 164.1691)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0958) and 
  (-0.0778, 30.1736) .. (-0.1736, 30.1736).. controls (-0.2693, 30.1736) and 
  (-0.3471, 30.0958) .. (-0.3471, 30.0).. controls (-0.3471, 29.9042) and 
  (-0.2693, 29.8267) .. (-0.1736, 29.8267).. controls (-0.0778, 29.8267) and 
  (0.0, 29.9042) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.794, 164.3441)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0773, 30.0) 
  and (-0.1402, 30.0627) .. (-0.1402, 30.14).. controls (-0.1402, 30.2172) and 
  (-0.0773, 30.2802) .. (0.0, 30.2802).. controls (0.0773, 30.2802) and (0.14, 
  30.2172) .. (0.14, 30.14).. controls (0.14, 30.0627) and (0.0773, 30.0) .. 
  (0.0, 30.0)(0.0, 30.3471).. controls (-0.1143, 30.3471) and (-0.2069, 30.2543)
   .. (-0.2069, 30.14).. controls (-0.2069, 30.0262) and (-0.1143, 29.9331) .. 
  (0.0, 29.9331).. controls (0.114, 29.9331) and (0.2069, 30.0262) .. (0.2069, 
  30.14).. controls (0.2069, 30.2543) and (0.114, 30.3471) .. (0.0, 30.3471);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.614, 163.2523)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.096) and 
  (-0.0778, 30.1736) .. (-0.1738, 30.1736).. controls (-0.2693, 30.1736) and 
  (-0.3471, 30.096) .. (-0.3471, 30.0).. controls (-0.3471, 29.9045) and 
  (-0.2693, 29.8267) .. (-0.1738, 29.8267).. controls (-0.0778, 29.8267) and 
  (0.0, 29.9045) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.8309, 163.4273)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0773, 30.0) 
  and (-0.1402, 30.063) .. (-0.1402, 30.14).. controls (-0.1402, 30.2175) and 
  (-0.0773, 30.2805) .. (0.0, 30.2805).. controls (0.077, 30.2805) and (0.14, 
  30.2175) .. (0.14, 30.14).. controls (0.14, 30.063) and (0.077, 30.0) .. (0.0,
   30.0)(0.0, 30.3471).. controls (-0.1143, 30.3471) and (-0.2069, 30.2543) .. 
  (-0.2069, 30.14).. controls (-0.2069, 30.0262) and (-0.1143, 29.9333) .. (0.0,
   29.9333).. controls (0.114, 29.9333) and (0.2069, 30.0262) .. (0.2069, 
  30.14).. controls (0.2069, 30.2543) and (0.114, 30.3471) .. (0.0, 30.3471);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.993, 161.9899)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0958) and 
  (-0.0778, 30.1736) .. (-0.1736, 30.1736).. controls (-0.2693, 30.1736) and 
  (-0.3471, 30.0958) .. (-0.3471, 30.0).. controls (-0.3471, 29.9042) and 
  (-0.2693, 29.8264) .. (-0.1736, 29.8264).. controls (-0.0778, 29.8264) and 
  (0.0, 29.9042) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.2099, 162.1652)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0773, 30.0) 
  and (-0.1402, 30.0627) .. (-0.1402, 30.14).. controls (-0.1402, 30.2172) and 
  (-0.0773, 30.2802) .. (0.0, 30.2802).. controls (0.0773, 30.2802) and (0.14, 
  30.2172) .. (0.14, 30.14).. controls (0.14, 30.0627) and (0.0773, 30.0) .. 
  (0.0, 30.0)(0.0, 30.3471).. controls (-0.1143, 30.3471) and (-0.2069, 30.2543)
   .. (-0.2069, 30.14).. controls (-0.2069, 30.0259) and (-0.1143, 29.9331) .. 
  (0.0, 29.9331).. controls (0.114, 29.9331) and (0.2069, 30.0259) .. (0.2069, 
  30.14).. controls (0.2069, 30.2543) and (0.114, 30.3471) .. (0.0, 30.3471);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-45.2567, 162.9342)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0958) and 
  (-0.0778, 30.1733) .. (-0.1736, 30.1733).. controls (-0.2693, 30.1733) and 
  (-0.3471, 30.0958) .. (-0.3471, 30.0).. controls (-0.3471, 29.9042) and 
  (-0.2693, 29.8267) .. (-0.1736, 29.8267).. controls (-0.0778, 29.8267) and 
  (0.0, 29.9042) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-45.4736, 163.1095)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0773, 30.0) 
  and (-0.14, 30.063) .. (-0.14, 30.1402).. controls (-0.14, 30.2175) and 
  (-0.0773, 30.2805) .. (0.0, 30.2805).. controls (0.0773, 30.2805) and (0.1402,
   30.2175) .. (0.1402, 30.1402).. controls (0.1402, 30.063) and (0.0773, 30.0) 
  .. (0.0, 30.0)(0.0, 30.3471).. controls (-0.114, 30.3471) and (-0.2069, 
  30.2543) .. (-0.2069, 30.1402).. controls (-0.2069, 30.0262) and (-0.114, 
  29.9333) .. (0.0, 29.9333).. controls (0.114, 29.9333) and (0.2069, 30.0262) 
  .. (0.2069, 30.1402).. controls (0.2069, 30.2543) and (0.114, 30.3471) .. 
  (0.0, 30.3471);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.8341, 164.5696)}]
      \path[fill=ce6ab39,nonzero rule] (0.0, 30.0) -- (0.0, 29.7579).. controls 
  (0.0, 29.7579) and (0.0098, 29.6825) .. (0.099, 29.6492).. controls (0.1879, 
  29.6158) and (0.2855, 29.7079) .. (0.2881, 29.7563).. controls (0.291, 29.805)
   and (0.2881, 30.0082) .. (0.2881, 30.0082).. controls (0.2881, 30.0082) and 
  (0.5665, 30.0474) .. (0.7501, 30.2159) -- (0.9284, 30.0376).. controls 
  (0.9284, 30.0376) and (1.0467, 29.9553) .. (1.1274, 30.0624).. controls 
  (1.1274, 30.0624) and (1.2234, 30.1614) .. (1.1052, 30.2757).. controls 
  (0.9869, 30.3897) and (0.9536, 30.4244) .. (0.9536, 30.4244).. controls 
  (0.9536, 30.4244) and (1.1232, 30.6779) .. (1.1356, 30.884) -- (1.4142, 
  30.8906).. controls (1.4142, 30.8906) and (1.5727, 30.9435) .. (1.5018, 
  31.1068).. controls (1.5018, 31.1068) and (1.4727, 31.1708) .. (1.36, 31.179) 
  -- (1.1372, 31.179).. controls (1.1372, 31.179) and (1.0925, 31.47) .. 
  (0.9536, 31.6327) -- (1.1454, 31.8259).. controls (1.1454, 31.8259) and 
  (1.1901, 31.9135) .. (1.1512, 31.969).. controls (1.112, 32.0246) and (1.0202,
   32.0952) .. (0.9192, 32.0153) -- (0.7512, 31.8428).. controls (0.7512, 
  31.8428) and (0.5776, 31.9971) .. (0.2929, 32.0513) -- (0.2929, 32.291).. 
  controls (0.2929, 32.291) and (0.2604, 32.4098) .. (0.1461, 32.4114).. 
  controls (0.1461, 32.4114) and (0.0265, 32.4125) .. (0.0, 32.2995) -- (0.0, 
  32.059).. controls (0.0, 32.059) and (-0.2521, 32.0452) .. (-0.4905, 31.8714) 
  -- (-0.6464, 32.0246).. controls (-0.6464, 32.0246) and (-0.7578, 32.0963) .. 
  (-0.8403, 31.9987).. controls (-0.9229, 31.9013) and (-0.8467, 31.8095) .. 
  (-0.8467, 31.8095) -- (-0.703, 31.6701).. controls (-0.703, 31.6701) and 
  (-0.8755, 31.456) .. (-0.9147, 31.1803) -- (-1.1385, 31.1758).. controls 
  (-1.1385, 31.1758) and (-1.2764, 31.1401) .. (-1.2401, 30.9798).. controls 
  (-1.2401, 30.9798) and (-1.2054, 30.8935) .. (-1.115, 30.884) -- (-0.9147, 
  30.8853).. controls (-0.9147, 30.8853) and (-0.8726, 30.5913) .. (-0.7056, 
  30.3884) -- (-0.8615, 30.2281).. controls (-0.8615, 30.2281) and (-0.9268, 
  30.0974) .. (-0.7977, 30.0251).. controls (-0.7977, 30.0251) and (-0.7112, 
  29.9651) .. (-0.604, 30.0765) -- (-0.4913, 30.1863).. controls (-0.4913, 
  30.1863) and (-0.2826, 30.0235) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.7924, 161.7005)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (0.0212, 30.0812) 
  and (0.1074, 30.0831) .. (0.1124, 30.0831).. controls (0.1902, 30.0818) and 
  (0.2199, 30.0087) .. (0.226, 29.9907) -- (0.226, 29.7285) -- (0.2529, 
  29.7232).. controls (0.5257, 29.6714) and (0.6937, 29.524) .. (0.6956, 
  29.5224) -- (0.7194, 29.5013) -- (0.9096, 29.6968).. controls (0.9305, 
  29.7129) and (0.9549, 29.7225) .. (0.9792, 29.7225).. controls (1.0261, 
  29.7225) and (1.0673, 29.6873) .. (1.0903, 29.6547).. controls (1.111, 
  29.6248) and (1.0946, 29.5732) .. (1.0845, 29.5505) -- (0.8747, 29.3391) -- 
  (0.8946, 29.3158).. controls (1.0261, 29.1618) and (1.0702, 28.8811) .. 
  (1.0708, 28.8787) -- (1.075, 28.8501) -- (1.3264, 28.8501).. controls (1.4131,
   28.8438) and (1.4375, 28.7988) .. (1.4383, 28.7967).. controls (1.4555, 
  28.7573) and (1.4579, 28.7221) .. (1.4452, 28.6932).. controls (1.428, 
  28.6541) and (1.3872, 28.6342) .. (1.374, 28.6287) -- (1.0708, 28.6213) -- 
  (1.0689, 28.5908).. controls (1.057, 28.3958) and (0.8938, 28.1503) .. 
  (0.8922, 28.1479) -- (0.8774, 28.1254) -- (0.8959, 28.1061).. controls 
  (0.8972, 28.1045) and (0.9311, 28.0696) .. (1.0485, 27.9561).. controls 
  (1.0806, 27.9254) and (1.097, 27.8939) .. (1.0972, 27.8627).. controls (1.098,
   27.8209) and (1.0702, 27.7907) .. (1.07, 27.7907).. controls (1.0462, 
  27.7592) and (1.0208, 27.7455) .. (0.9903, 27.7455).. controls (0.9554, 
  27.7455) and (0.9245, 27.7635) .. (0.916, 27.7685) -- (0.7178, 27.9667) -- 
  (0.6943, 27.945).. controls (0.5207, 27.786) and (0.2527, 27.7465) .. (0.25, 
  27.7463) -- (0.2209, 27.742) -- (0.2212, 27.7124).. controls (0.2212, 27.7108)
   and (0.2241, 27.51) .. (0.2212, 27.4632).. controls (0.2201, 27.4428) and 
  (0.1664, 27.3804) .. (0.105, 27.3804) -- (0.077, 27.3851).. controls (0.0087, 
  27.4111) and (-0.0003, 27.4664) .. (-0.0003, 27.4669) -- (0.0, 27.7354) -- 
  (-0.0307, 27.7378).. controls (-0.3003, 27.7606) and (-0.5022, 27.9159) .. 
  (-0.5043, 27.9175) -- (-0.5273, 27.9355) -- (-0.6609, 27.8053).. controls 
  (-0.6977, 27.7672) and (-0.7355, 27.7468) .. (-0.7707, 27.7468).. controls 
  (-0.7961, 27.7468) and (-0.8117, 27.7571) .. (-0.8125, 27.7577).. controls 
  (-0.9046, 27.8093) and (-0.8758, 27.8937) .. (-0.867, 27.9138) -- (-0.6943, 
  28.091) -- (-0.7133, 28.1143).. controls (-0.8726, 28.3083) and (-0.9144, 
  28.5919) .. (-0.9149, 28.5948) -- (-0.9192, 28.6236) -- (-1.1486, 28.6218).. 
  controls (-1.2078, 28.6284) and (-1.2364, 28.6834) .. (-1.2417, 28.6948).. 
  controls (-1.2655, 28.8073) and (-1.1867, 28.8409) .. (-1.1668, 28.8477) -- 
  (-0.9189, 28.8522) -- (-0.9149, 28.8803).. controls (-0.8776, 29.1433) and 
  (-0.712, 29.352) .. (-0.7104, 29.3542) -- (-0.6914, 29.378) -- (-0.857, 
  29.538).. controls (-0.8602, 29.5425) and (-0.9099, 29.6089) .. (-0.8483, 
  29.6817).. controls (-0.8258, 29.7087) and (-0.7996, 29.7214) .. (-0.7684, 
  29.7214).. controls (-0.7363, 29.7214) and (-0.7088, 29.7074) .. (-0.7001, 
  29.7029) -- (-0.5271, 29.5325) -- (-0.5043, 29.5494).. controls (-0.2773, 
  29.7145) and (-0.0339, 29.7304) .. (-0.0318, 29.7307) -- (0.0, 29.7322) -- 
  cycle(0.1124, 30.1498).. controls (0.0582, 30.1498) and (-0.0405, 30.1207) .. 
  (-0.0659, 30.0119) -- (-0.0669, 30.0042) -- (-0.0669, 29.7942).. controls 
  (-0.1408, 29.7849) and (-0.3313, 29.7494) .. (-0.5204, 29.6195) -- (-0.6617, 
  29.7576).. controls (-0.6638, 29.7587) and (-0.7101, 29.7881) .. (-0.7684, 
  29.7881).. controls (-0.8192, 29.7881) and (-0.8641, 29.7664) .. (-0.8991, 
  29.7251).. controls (-0.979, 29.6312) and (-0.9385, 29.5322) .. (-0.9059, 
  29.4931) -- (-0.7808, 29.3716).. controls (-0.8255, 29.3092) and (-0.9387, 
  29.1356) .. (-0.9766, 28.9179) -- (-1.1806, 28.9134).. controls (-1.239, 
  28.8977) and (-1.3404, 28.8287) .. (-1.3062, 28.6771) -- (-1.3047, 28.6723).. 
  controls (-1.3028, 28.6678) and (-1.2613, 28.567) .. (-1.152, 28.5554) -- 
  (-0.976, 28.5564).. controls (-0.9615, 28.4792) and (-0.9118, 28.2649) .. 
  (-0.7834, 28.0955) -- (-0.925, 27.9479).. controls (-0.9525, 27.8926) and 
  (-0.9718, 27.7701) .. (-0.8475, 27.7008).. controls (-0.8469, 27.7002) and 
  (-0.817, 27.6804) .. (-0.7707, 27.6804).. controls (-0.7332, 27.6804) and 
  (-0.6755, 27.6936) .. (-0.6136, 27.7579) -- (-0.5215, 27.8476).. controls 
  (-0.4606, 27.8058) and (-0.2892, 27.701) .. (-0.0669, 27.6746) -- (-0.0669, 
  27.4626).. controls (-0.0661, 27.4544) and (-0.0529, 27.3626) .. (0.0537, 
  27.3227) -- (0.105, 27.3134).. controls (0.195, 27.3134) and (0.2844, 27.3954)
   .. (0.2879, 27.4592).. controls (0.2902, 27.4978) and (0.2889, 27.627) .. 
  (0.2884, 27.6849).. controls (0.3627, 27.6994) and (0.5617, 27.7476) .. 
  (0.7152, 27.8749) -- (0.876, 27.7148).. controls (0.8779, 27.7135) and 
  (0.9284, 27.6788) .. (0.9903, 27.6788).. controls (1.0419, 27.6788) and 
  (1.0869, 27.7024) .. (1.1205, 27.7473) -- (1.1205, 27.7471).. controls (1.121,
   27.7471) and (1.1652, 27.7944) .. (1.1642, 27.8638).. controls (1.1631, 
  27.9132) and (1.1401, 27.9609) .. (1.0948, 28.0042).. controls (1.0237, 
  28.073) and (0.9832, 28.113) .. (0.9626, 28.1336).. controls (1.0028, 28.1985)
   and (1.1115, 28.3855) .. (1.1327, 28.5559) -- (1.3912, 28.5638).. controls 
  (1.3946, 28.5649) and (1.4732, 28.5919) .. (1.506, 28.6654).. controls 
  (1.5269, 28.7125) and (1.5245, 28.766) .. (1.4989, 28.8247).. controls 
  (1.4973, 28.8284) and (1.46, 28.9073) .. (1.3287, 28.9168) -- (1.1316, 
  28.9171).. controls (1.1173, 28.9917) and (1.0702, 29.1949) .. (0.9647, 
  29.3348) -- (1.1417, 29.5158).. controls (1.1441, 29.52) and (1.1949, 29.6216)
   .. (1.1449, 29.6931).. controls (1.1123, 29.7397) and (1.0517, 29.7894) .. 
  (0.9792, 29.7894).. controls (0.9395, 29.7894) and (0.9012, 29.7751) .. 
  (0.8649, 29.7463) -- (0.7149, 29.5928).. controls (0.6585, 29.6359) and 
  (0.5096, 29.7365) .. (0.2926, 29.7836) -- (0.2916, 30.0048).. controls 
  (0.2781, 30.054) and (0.2233, 30.1482) .. (0.1132, 30.1498) -- (0.1124, 
  30.1498);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.6755, 163.2768)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.4474) and 
  (-0.3649, 30.8102) .. (-0.8149, 30.8102).. controls (-1.265, 30.8102) and 
  (-1.6298, 30.4474) .. (-1.6298, 30.0).. controls (-1.6298, 29.5529) and 
  (-1.265, 29.1901) .. (-0.8149, 29.1901).. controls (-0.3649, 29.1901) and 
  (0.0, 29.5529) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.6942, 164.2475)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.4307, 30.0) 
  and (-0.7816, 30.3485) .. (-0.7816, 30.7766).. controls (-0.7816, 31.2052) and
   (-0.4307, 31.5534) .. (0.0, 31.5534).. controls (0.431, 31.5534) and (0.7816,
   31.2052) .. (0.7816, 30.7766).. controls (0.7816, 30.3485) and (0.431, 30.0) 
  .. (0.0, 30.0)(0.0, 31.6203).. controls (-0.4678, 31.6203) and (-0.8483, 
  31.242) .. (-0.8483, 30.7766).. controls (-0.8483, 30.3117) and (-0.4678, 
  29.9333) .. (0.0, 29.9333).. controls (0.4678, 29.9333) and (0.8485, 30.3117) 
  .. (0.8485, 30.7766).. controls (0.8485, 31.242) and (0.4678, 31.6203) .. 
  (0.0, 31.6203);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.9775, 163.2818)}]
      \path[fill=ce6ab39,nonzero rule] (0.0, 30.0).. controls (0.0, 30.3133) and
   (-0.254, 30.5673) .. (-0.5675, 30.5673).. controls (-0.8808, 30.5673) and 
  (-1.1351, 30.3133) .. (-1.1351, 30.0).. controls (-1.1351, 29.6862) and 
  (-0.8808, 29.4322) .. (-0.5675, 29.4322).. controls (-0.254, 29.4322) and 
  (0.0, 29.6862) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.6866, 163.9498)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.2945, 30.0) 
  and (-0.5342, 30.2397) .. (-0.5342, 30.5339).. controls (-0.5342, 30.8287) and
   (-0.2945, 31.0681) .. (0.0, 31.0681).. controls (0.2942, 31.0681) and 
  (0.5339, 30.8287) .. (0.5339, 30.5339).. controls (0.5339, 30.2397) and 
  (0.2942, 30.0) .. (0.0, 30.0)(0.0, 31.1348).. controls (-0.3313, 31.1348) and 
  (-0.6009, 30.8655) .. (-0.6009, 30.5339).. controls (-0.6009, 30.2029) and 
  (-0.3313, 29.9333) .. (0.0, 29.9333).. controls (0.3313, 29.9333) and (0.6009,
   30.2029) .. (0.6009, 30.5339).. controls (0.6009, 30.8655) and (0.3313, 
  31.1348) .. (0.0, 31.1348);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.3049, 163.2861)}]
      \path[fill=white,nonzero rule] (0.0, 30.0).. controls (0.0, 30.1749) and 
  (-0.1418, 30.317) .. (-0.3167, 30.317).. controls (-0.4919, 30.317) and 
  (-0.6337, 30.1749) .. (-0.6337, 30.0).. controls (-0.6337, 29.8251) and 
  (-0.4919, 29.683) .. (-0.3167, 29.683).. controls (-0.1418, 29.683) and (0.0, 
  29.8251) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.7008, 163.6406)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.1564, 30.0) 
  and (-0.2836, 30.1273) .. (-0.2836, 30.2834).. controls (-0.2836, 30.4397) and
   (-0.1564, 30.567) .. (0.0, 30.567).. controls (0.1561, 30.567) and (0.2834, 
  30.4397) .. (0.2834, 30.2834).. controls (0.2834, 30.1273) and (0.1561, 30.0) 
  .. (0.0, 30.0)(0.0, 30.6334).. controls (-0.1934, 30.6334) and (-0.3503, 
  30.4765) .. (-0.3503, 30.2834).. controls (-0.3503, 30.0905) and (-0.1934, 
  29.9333) .. (0.0, 29.9333).. controls (0.1931, 29.9333) and (0.3503, 30.0905) 
  .. (0.3503, 30.2834).. controls (0.3503, 30.4765) and (0.1931, 30.6334) .. 
  (0.0, 30.6334);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.7006, 163.3969)}]
      \path[fill=c638e8c,nonzero rule] (0.0, 30.0) -- (0.2529, 29.9886).. 
  controls (0.2529, 29.9886) and (0.2648, 29.8373) .. (0.4141, 29.6862) -- 
  (0.2072, 29.555).. controls (0.2072, 29.555) and (0.0516, 29.6965) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.435, 163.8992)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0378, 30.0429)
   and (-0.1286, 30.163) .. (-0.1717, 30.3664) -- (0.0119, 30.3582).. controls 
  (0.0222, 30.3085) and (0.054, 30.204) .. (0.1498, 30.0947) -- cycle(-0.2524, 
  30.4368) -- (-0.2453, 30.3961).. controls (-0.1924, 30.0849) and (-0.0344, 
  29.9384) .. (-0.0278, 29.9323) -- (-0.009, 29.9153) -- (0.2548, 30.0818) -- 
  (0.2257, 30.1114).. controls (0.0876, 30.2511) and (0.0741, 30.3913) .. 
  (0.0741, 30.3929) -- (0.0714, 30.4223) -- (-0.2524, 30.4368);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.0021, 163.9174)}]
      \path[fill=c638e8c,nonzero rule] (0.0, 30.0) -- (-0.1058, 29.7857).. 
  controls (-0.1058, 29.7857) and (0.1363, 29.6425) .. (0.4395, 29.7248) -- 
  (0.3815, 29.9558).. controls (0.3815, 29.9558) and (0.1762, 29.8981) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.0788, 164.1668)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (0.0762, 30.154).. 
  controls (0.1434, 30.122) and (0.2199, 30.1056) .. (0.3043, 30.1056).. 
  controls (0.3519, 30.1056) and (0.3921, 30.1111) .. (0.4183, 30.1156) -- 
  (0.4604, 29.9489).. controls (0.4109, 29.9378) and (0.3601, 29.9323) .. 
  (0.309, 29.9323).. controls (0.1646, 29.9323) and (0.0503, 29.9765) .. (0.0, 
  30.0)(0.0471, 30.2463) -- (-0.0884, 29.972) -- (-0.0614, 29.9563).. controls 
  (-0.0553, 29.9524) and (0.095, 29.8653) .. (0.309, 29.8653).. controls (0.377,
   29.8653) and (0.4445, 29.8743) .. (0.5096, 29.8921) -- (0.5411, 29.9005) -- 
  (0.4673, 30.1966) -- (0.4342, 30.1876).. controls (0.4337, 30.1873) and 
  (0.3791, 30.1725) .. (0.3043, 30.1725).. controls (0.2183, 30.1725) and 
  (0.1423, 30.1913) .. (0.0781, 30.2283) -- (0.0471, 30.2463);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.1827, 163.7891)}]
      \path[fill=c0c3c5d,nonzero rule] (0.0, 30.0) -- (-0.2072, 29.869).. 
  controls (-0.2072, 29.869) and (-0.0945, 29.7365) .. (0.0386, 29.6828) -- 
  (0.1445, 29.8971).. controls (0.1445, 29.8971) and (0.0429, 29.9524) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.3768, 163.9611)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (0.1508, 30.0953).. 
  controls (0.1834, 30.0664) and (0.2275, 30.0384) .. (0.2559, 30.0214) -- 
  (0.1781, 29.864).. controls (0.1024, 29.9021) and (0.0352, 29.964) .. (0.0, 
  30.0)(0.1611, 30.181) -- (-0.1024, 30.0143) -- (-0.0775, 29.9849).. controls 
  (-0.0725, 29.9794) and (0.0421, 29.8457) .. (0.1812, 29.7894) -- (0.2101, 
  29.7778) -- (0.3437, 30.0487) -- (0.3156, 30.0643).. controls (0.2887, 
  30.0788) and (0.2119, 30.1246) .. (0.1802, 30.1598) -- (0.1611, 30.181);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.3464, 163.544)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.2238, 29.9071) -- 
  (-0.1982, 29.8457) -- (0.0254, 29.9384) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.8043, 163.9849)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.014, 29.7584) -- 
  (0.0527, 29.7545) -- (0.0667, 29.9958) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.29, 163.8685)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.055, 29.9624) -- 
  (0.0796, 29.7653) -- (0.1347, 29.8032) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.6801, 163.0681)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0103, 29.9341) -- 
  (0.222, 29.8973) -- (0.2326, 29.9632) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.5938, 162.5985)}]
      \path[fill=white,nonzero rule] (0.0, 30.0) -- (0.0656, 30.09);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.5455, 162.4616)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0656, 29.9103) -- 
  (-0.0116, 29.8709) -- (0.054, 29.9608) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.8673, 162.4678)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0561, 29.9201) -- 
  (-0.0011, 29.882) -- (0.0548, 29.9614) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.8485, 154.1067)}]
      \path[fill=ce5ae4a,even odd rule] (0.0, 30.0).. controls (0.0548, 30.1109)
   and (0.0746, 30.2267) .. (-0.0331, 30.3231).. controls (-0.2048, 30.4763) and
   (-0.6615, 30.6691) .. (-0.6615, 30.6691).. controls (-0.6615, 30.6691) and 
  (-0.8943, 30.7488) .. (-0.8575, 30.8866).. controls (-0.8207, 31.0247) and 
  (-0.7678, 30.9895) .. (-0.7678, 30.9895) -- (-0.6056, 31.0507) -- (-0.476, 
  31.0909).. controls (-0.476, 31.0909) and (-0.4268, 31.1181) .. (-0.3487, 
  31.0832).. controls (-0.2709, 31.048) and (-0.2553, 31.0919) .. (-0.2553, 
  31.0919) -- (-0.227, 31.1065).. controls (-0.227, 31.1065) and (-0.1762, 
  31.1467) .. (-0.1048, 31.1155).. controls (-0.0336, 31.084) and (0.0259, 
  30.9985) .. (0.05, 30.9583).. controls (0.0741, 30.9184) and (0.1339, 30.8496)
   .. (0.1662, 30.917).. controls (0.1987, 30.9845) and (0.1781, 31.0713) .. 
  (0.1781, 31.0713).. controls (0.1781, 31.0713) and (0.3077, 30.9985) .. 
  (0.2974, 30.8729).. controls (0.2974, 30.8729) and (0.4114, 31.0274) .. 
  (0.3543, 31.1607).. controls (0.3543, 31.1607) and (0.6458, 30.9239) .. 
  (0.5339, 30.6694) -- (0.6503, 30.9678).. controls (0.6503, 30.9678) and 
  (0.725, 30.7969) .. (0.7533, 30.7398).. controls (0.7818, 30.6826) and 
  (0.7906, 30.5159) .. (0.7313, 30.435) -- (0.7072, 30.4019).. controls (0.7072,
   30.4019) and (0.7678, 30.3537) .. (0.7509, 30.2879).. controls (0.7342, 
  30.2223) and (0.5424, 29.9762) .. (0.5514, 29.8344).. controls (0.5514, 
  29.8344) and (0.5308, 29.5748) .. (0.69, 29.4714) -- (0.5612, 28.9578) -- 
  (0.0561, 28.8787) -- (-0.2712, 28.9345).. controls (-0.2712, 28.9345) and 
  (-0.4106, 29.2594) .. (-0.3807, 29.3872).. controls (-0.3535, 29.5042) and 
  (-0.2733, 29.5986) .. (-0.2016, 29.6918).. controls (-0.1278, 29.7873) and 
  (-0.0537, 29.8918) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.1379, 152.7735)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (0.0257, 30.0135).. 
  controls (0.0259, 30.014) and (0.0442, 30.0273) .. (0.0725, 30.0273) -- 
  (0.1135, 30.018).. controls (0.167, 29.9947) and (0.2207, 29.9288) .. (0.2529,
   29.8746).. controls (0.2651, 29.8545) and (0.3088, 29.7886) .. (0.3627, 
  29.7886).. controls (0.3786, 29.7886) and (0.4083, 29.7949) .. (0.4281, 
  29.8357).. controls (0.4426, 29.8664) and (0.4479, 29.8997) .. (0.4493, 
  29.9291).. controls (0.4755, 29.9003) and (0.4998, 29.8595) .. (0.4956, 
  29.8087) -- (0.486, 29.692) -- (0.5556, 29.7862).. controls (0.5596, 29.7915) 
  and (0.6292, 29.887) .. (0.635, 29.9979).. controls (0.7041, 29.9182) and 
  (0.7924, 29.7809) .. (0.744, 29.6388) -- (0.7345, 29.615) -- (0.7964, 29.5894)
   -- (0.807, 29.6171) -- (0.8837, 29.814).. controls (0.9078, 29.7603) and 
  (0.9387, 29.691) .. (0.9551, 29.6582).. controls (0.9795, 29.6092) and 
  (0.9861, 29.4565) .. (0.9361, 29.3883) -- (0.8932, 29.3293) -- (0.9181, 
  29.3097).. controls (0.9184, 29.3092) and (0.9615, 29.2732) .. (0.9504, 
  29.2295).. controls (0.9459, 29.2123) and (0.9197, 29.1682) .. (0.894, 
  29.125).. controls (0.8308, 29.0187) and (0.7443, 28.8731) .. (0.7496, 
  28.7681).. controls (0.7477, 28.7401) and (0.7371, 28.5056) .. (0.8837, 
  28.3911) -- (0.766, 27.9212) -- (0.2879, 27.8458) -- (-0.0159, 27.8979).. 
  controls (-0.0566, 27.9971) and (-0.1378, 28.2223) .. (-0.1167, 28.3128).. 
  controls (-0.0937, 28.412) and (-0.0278, 28.4964) .. (0.036, 28.5784) -- 
  (0.0564, 28.6049).. controls (0.1209, 28.6885) and (0.2024, 28.7996) .. 
  (0.2614, 28.9184).. controls (0.3368, 29.0708) and (0.3236, 29.1893) .. 
  (0.2207, 29.2811).. controls (0.0471, 29.4364) and (-0.3979, 29.6256) .. 
  (-0.4167, 29.6336).. controls (-0.421, 29.6351) and (-0.6215, 29.7071) .. 
  (-0.5937, 29.8116).. controls (-0.5734, 29.8878) and (-0.5519, 29.8936) .. 
  (-0.5517, 29.8936) -- (-0.5374, 29.8838) -- (-0.5244, 29.8915) -- (-0.3622, 
  29.9524) -- (-0.2281, 29.9947) -- (-0.1942, 30.0008) -- (-0.1307, 29.986).. 
  controls (-0.1064, 29.9749) and (-0.0841, 29.9696) .. (-0.0648, 29.9696).. 
  controls (-0.0315, 29.9696) and (-0.0108, 29.9849) .. (0.0, 30.0)(0.5022, 
  30.2053) -- (0.5554, 30.0812).. controls (0.581, 30.0212) and (0.5657, 29.955)
   .. (0.545, 29.905).. controls (0.5088, 29.9865) and (0.4305, 30.0312) .. 
  (0.426, 30.0339) -- (0.3598, 30.0709) -- (0.377, 29.9968).. controls (0.3773, 
  29.9963) and (0.3945, 29.9204) .. (0.368, 29.8648) -- (0.3612, 29.8547).. 
  controls (0.3543, 29.8555) and (0.3297, 29.8767) .. (0.3104, 29.909).. 
  controls (0.2868, 29.9484) and (0.2233, 30.0431) .. (0.14, 30.0794) -- 
  (0.0725, 30.0942).. controls (0.0283, 30.0942) and (-0.0024, 30.0754) .. 
  (-0.0127, 30.0683) -- (-0.0505, 30.0495) -- (-0.0553, 30.0368) -- (-0.0648, 
  30.0362) -- (-0.1035, 30.0468).. controls (-0.1341, 30.0609) and (-0.1648, 
  30.0677) .. (-0.1942, 30.0677).. controls (-0.2262, 30.0677) and (-0.2479, 
  30.0595) .. (-0.2566, 30.0553) -- (-0.3839, 30.0159) -- (-0.5363, 29.9587) -- 
  (-0.5517, 29.9606).. controls (-0.599, 29.9606) and (-0.6347, 29.9164) .. 
  (-0.658, 29.8291).. controls (-0.7025, 29.6627) and (-0.4514, 29.5748) .. 
  (-0.4405, 29.5711).. controls (-0.4382, 29.5701) and (0.0108, 29.3793) .. 
  (0.1762, 29.2317).. controls (0.2559, 29.1607) and (0.2635, 29.0732) .. 
  (0.2019, 28.9483).. controls (0.1453, 28.8345) and (0.0661, 28.7268) .. 
  (0.0037, 28.6456) -- (-0.0167, 28.6194).. controls (-0.0849, 28.5318) and 
  (-0.1553, 28.4413) .. (-0.1818, 28.3281).. controls (-0.2133, 28.1934) and 
  (-0.0849, 27.8892) .. (-0.0701, 27.855) -- (-0.063, 27.8384) -- (0.2873, 
  27.7783) -- (0.2929, 27.7791) -- (0.8199, 27.8619) -- (0.9599, 28.4199) -- 
  (0.9398, 28.4329).. controls (0.7993, 28.5242) and (0.8162, 28.7628) .. 
  (0.8162, 28.7655) -- (0.8165, 28.7676) -- (0.8165, 28.77).. controls (0.8109, 
  28.8546) and (0.8956, 28.997) .. (0.9514, 29.0912).. controls (0.9877, 29.152)
   and (1.0086, 29.1883) .. (1.0149, 29.2129).. controls (1.0292, 29.2682) and 
  (1.0033, 29.3129) .. (0.9824, 29.3385) -- (0.9901, 29.3486).. controls 
  (1.0605, 29.4454) and (1.0459, 29.6259) .. (1.0149, 29.6878).. controls 
  (0.9872, 29.7436) and (0.9133, 29.9127) .. (0.9125, 29.9145) -- (0.8803, 
  29.9886) -- (0.8125, 29.8156).. controls (0.7684, 29.987) and (0.616, 30.1132)
   .. (0.6072, 30.1201) -- (0.5022, 30.2053);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.2913, 154.9748)}]
      \path[fill=cc08532,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.4485, 30.004) .. (0.5773, 30.2299) -- (0.5763, 30.2921).. controls (0.5765,
   30.3495) and (0.5797, 30.4072) .. (0.585, 30.4643).. controls (0.5929, 
  30.5421) and (0.6054, 30.6197) .. (0.6244, 30.6956).. controls (0.6345, 
  30.7363) and (0.6458, 30.7776) .. (0.6617, 30.817).. controls (0.6731, 
  30.8453) and (0.6993, 30.8744) .. (0.703, 30.9046).. controls (0.7115, 
  30.9723) and (0.4895, 31.0882) .. (0.4405, 31.1187).. controls (0.2514, 
  31.2369) and (0.055, 31.3436) .. (-0.1416, 31.4486) -- (-0.1032, 31.4769).. 
  controls (-0.0685, 31.493) and (0.2802, 31.5214) .. (0.2839, 31.4817).. 
  controls (0.3112, 31.4068) and (0.4389, 31.4925) .. (0.4958, 31.4846).. 
  controls (0.5527, 31.4774) and (1.0893, 31.0557) .. (1.0795, 31.0176).. 
  controls (1.0454, 30.8816) and (0.9406, 30.7752) .. (0.9022, 30.6355).. 
  controls (0.8845, 30.571) and (0.8768, 30.4982) .. (0.8877, 30.4323).. 
  controls (0.8919, 30.4072) and (0.9758, 30.1677) .. (0.9922, 30.1818).. 
  controls (0.9922, 30.1818) and (0.9803, 30.1717) .. (0.9374, 29.9659).. 
  controls (0.8946, 29.7592) and (0.8885, 29.786) .. (0.8885, 29.786).. controls
   (0.8885, 29.786) and (0.4969, 29.5917) .. (0.1963, 29.6891).. controls 
  (0.1963, 29.6891) and (0.0474, 29.8024) .. (0.0407, 29.8383).. controls 
  (0.0339, 29.8738) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.583, 156.7426)}]
      \path[fill=ce5ae4a,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.4696, 30.0915) .. (0.7504, 29.9775).. controls (1.0308, 29.8637) and 
  (1.1546, 29.9005) .. (1.1546, 29.9005) -- (1.6367, 29.9648).. controls 
  (1.6367, 29.9648) and (1.7587, 30.0021) .. (2.3704, 30.0709).. controls 
  (2.3704, 30.0709) and (3.1554, 30.1402) .. (3.3605, 30.0122).. controls 
  (3.3605, 30.0122) and (3.8296, 29.8635) .. (3.7285, 29.3772).. controls 
  (3.7285, 29.3772) and (3.5518, 28.9337) .. (2.9321, 28.988).. controls 
  (2.3122, 29.0417) and (2.3302, 29.4706) .. (2.431, 29.5648).. controls 
  (2.5321, 29.6582) and (2.622, 29.741) .. (2.622, 29.741).. controls (2.622, 
  29.741) and (2.5572, 29.701) .. (2.4088, 29.6891).. controls (2.2603, 29.6769)
   and (2.1802, 29.6703) .. (2.0931, 29.5526).. controls (2.0061, 29.4349) and 
  (2.0386, 29.3801) .. (2.0386, 29.3801).. controls (2.0386, 29.3801) and 
  (1.955, 29.5851) .. (1.5438, 29.7182).. controls (1.5438, 29.7182) and 
  (1.4229, 29.7481) .. (1.307, 29.7703).. controls (1.307, 29.7703) and (1.474, 
  29.6873) .. (1.5028, 29.4195).. controls (1.5028, 29.4195) and (1.4243, 
  29.4333) .. (1.3629, 29.5047).. controls (1.3018, 29.5767) and (1.1284, 
  29.7764) .. (0.8469, 29.6809).. controls (0.8369, 29.6865) and (0.8289, 
  29.6791) .. (0.8184, 29.6717).. controls (0.8096, 29.6656) and (0.7993, 
  29.6592) .. (0.7845, 29.6608).. controls (0.7845, 29.6608) and (0.8665, 
  29.6232) .. (0.943, 29.6023).. controls (0.9991, 29.5873) and (1.0673, 
  29.5314) .. (1.088, 29.4764).. controls (1.1218, 29.387) and (0.9223, 29.4195)
   .. (0.8824, 29.4251).. controls (0.8297, 29.4322) and (0.7776, 29.4423) .. 
  (0.7255, 29.4523).. controls (0.6578, 29.4655) and (0.5898, 29.4621) .. 
  (0.5199, 29.4581).. controls (0.3723, 29.4491) and (0.2159, 29.4261) .. 
  (0.0847, 29.3547).. controls (-0.1619, 29.22) and (-0.3299, 29.039) .. 
  (-0.2884, 28.7446).. controls (-0.2469, 28.4498) and (0.2135, 28.2675) .. 
  (0.2619, 28.2561).. controls (0.3104, 28.2448) and (0.4561, 28.2093) .. 
  (1.0652, 28.1868).. controls (1.0652, 28.1868) and (1.2771, 28.2246) .. 
  (1.4999, 27.9929).. controls (1.723, 27.7611) and (2.0212, 27.7786) .. 
  (2.0212, 27.7786).. controls (2.0212, 27.7786) and (2.3455, 27.7569) .. 
  (2.4868, 27.4476).. controls (2.4868, 27.4476) and (2.5024, 27.7264) .. 
  (2.3852, 27.8561).. controls (2.3852, 27.8561) and (2.6699, 27.6926) .. 
  (2.712, 27.6685).. controls (2.7538, 27.6442) and (2.9591, 27.5338) .. 
  (3.2396, 27.6442).. controls (3.52, 27.7545) and (3.701, 27.7569) .. (3.7671, 
  27.6484).. controls (3.7671, 27.6484) and (3.7097, 27.8206) .. (3.3168, 
  27.869).. controls (3.3168, 27.869) and (3.1136, 27.8516) .. (2.9194, 28.09)..
   controls (2.8686, 28.1527) and (2.7996, 28.1752) .. (2.7355, 28.218).. 
  controls (2.7826, 28.2313) and (2.8337, 28.2217) .. (2.8813, 28.2392).. 
  controls (2.9289, 28.2561) and (2.9731, 28.2821) .. (3.0131, 28.3133).. 
  controls (3.0596, 28.3498) and (3.1393, 28.4128) .. (3.1599, 28.4697).. 
  controls (3.1599, 28.4697) and (3.1052, 28.3175) .. (2.6765, 28.4958).. 
  controls (2.2484, 28.6747) and (2.1071, 28.6562) .. (1.8246, 28.562).. 
  controls (1.542, 28.4675) and (1.4428, 28.3326) .. (1.18, 28.3461).. controls 
  (1.18, 28.3461) and (0.5575, 28.2622) .. (0.0807, 28.5183).. controls (0.0807,
   28.5183) and (-0.2746, 28.7369) .. (0.0542, 29.0546).. controls (0.0542, 
  29.0546) and (0.2839, 29.3018) .. (0.9792, 29.1893).. controls (1.6745, 
  29.0769) and (2.0167, 28.9176) .. (2.1754, 28.9044).. controls (2.3344, 
  28.8914) and (2.9107, 28.7014) .. (3.3652, 28.7961).. controls (3.8201, 
  28.8914) and (3.9812, 29.284) .. (3.9812, 29.284).. controls (3.9812, 29.284) 
  and (4.0958, 29.5203) .. (3.9965, 29.7232).. controls (3.8973, 29.9264) and 
  (3.8182, 30.0143) .. (3.8182, 30.0143).. controls (3.8182, 30.0143) and 
  (4.105, 30.164) .. (4.0074, 30.5056).. controls (4.0074, 30.5056) and (4.0039,
   30.3625) .. (3.8153, 30.3463).. controls (3.6266, 30.3299) and (3.4867, 
  30.2453) .. (3.4801, 30.2291).. controls (3.4801, 30.2291) and (3.2552, 
  30.3223) .. (2.8289, 30.3495).. controls (2.8289, 30.3495) and (2.9223, 
  30.4654) .. (3.125, 30.5456).. controls (3.125, 30.5456) and (2.6323, 30.7019)
   .. (2.486, 30.4641).. controls (2.486, 30.4641) and (2.4445, 30.594) .. 
  (2.6183, 30.6358).. controls (2.6183, 30.6358) and (2.3638, 30.7464) .. 
  (2.1773, 30.5469).. controls (2.1773, 30.5469) and (2.2511, 30.7308) .. 
  (2.2548, 31.0385).. controls (2.2585, 31.3462) and (2.2659, 31.5073) .. 
  (2.4834, 31.6386).. controls (2.7011, 31.7703) and (2.8175, 31.7552) .. 
  (2.8175, 31.7552).. controls (2.8175, 31.7552) and (2.8665, 31.9127) .. 
  (2.794, 32.0029).. controls (2.794, 32.0029) and (2.8313, 32.06) .. (3.0641, 
  32.0717).. controls (3.3025, 32.0836) and (3.2464, 32.3932) .. (3.4092, 
  32.4225).. controls (3.4092, 32.4225) and (3.3663, 32.4696) .. (3.2195, 
  32.3794).. controls (3.0721, 32.2892) and (2.98, 32.4011) .. (2.98, 32.4011)..
   controls (2.98, 32.4011) and (3.1806, 32.45) .. (3.1845, 32.6535).. controls 
  (3.189, 32.8572) and (3.2179, 32.9387) .. (3.2179, 32.9387).. controls 
  (3.2179, 32.9387) and (3.1673, 32.9049) .. (3.0959, 32.8181).. controls 
  (3.0242, 32.7313) and (2.8945, 32.7511) .. (2.8945, 32.7511).. controls 
  (2.8945, 32.7511) and (3.0287, 32.8202) .. (3.0094, 33.0303).. controls 
  (3.0094, 33.0303) and (2.9961, 33.1406) .. (3.044, 33.171).. controls (3.044, 
  33.171) and (2.9096, 33.1366) .. (2.8512, 33.0411).. controls (2.8512, 
  33.0411) and (2.7374, 33.1345) .. (2.7302, 33.2131).. controls (2.7231, 
  33.2917) and (2.7398, 33.5248) .. (2.5609, 33.5528).. controls (2.382, 
  33.5803) and (2.4127, 33.47) .. (2.4127, 33.47).. controls (2.4127, 33.47) and
   (2.39, 33.5795) .. (2.1466, 33.4967).. controls (2.1466, 33.4967) and 
  (1.9484, 33.4946) .. (1.9407, 33.4171).. controls (1.9407, 33.4171) and 
  (1.7992, 33.4663) .. (1.7862, 33.3494).. controls (1.773, 33.2324) and 
  (1.9241, 33.2136) .. (1.9542, 33.2001).. controls (1.9844, 33.1872) and 
  (2.186, 33.1139) .. (2.1982, 32.8596).. controls (2.2106, 32.6056) and 
  (2.1291, 32.2797) .. (2.0577, 32.1664).. controls (1.986, 32.0529) and 
  (1.8283, 31.969) .. (1.6259, 31.9148).. controls (1.4237, 31.8606) and 
  (1.2668, 31.7253) .. (1.2197, 31.5036).. controls (1.1726, 31.2824) and 
  (1.1507, 31.1917) .. (1.1216, 31.1734).. controls (1.0927, 31.1552) and 
  (0.7115, 30.9776) .. (0.3977, 31.0898).. controls (0.3977, 31.0898) and 
  (0.5271, 31.1795) .. (0.5683, 31.2435).. controls (0.5683, 31.2435) and 
  (0.4974, 31.1795) .. (0.3196, 31.2245).. controls (0.1421, 31.2695) and 
  (0.0437, 31.2002) .. (0.0437, 31.2002).. controls (0.0437, 31.2002) and 
  (0.0648, 31.3486) .. (0.1971, 31.4026).. controls (0.1971, 31.4026) and 
  (0.1511, 31.4078) .. (0.0283, 31.4235).. controls (-0.095, 31.4388) and 
  (-0.1879, 31.4078) .. (-0.2103, 31.3592).. controls (-0.2103, 31.3592) and 
  (-0.1355, 31.5719) .. (-0.0153, 31.624).. controls (-0.0153, 31.624) and 
  (-0.1214, 31.5872) .. (-0.2852, 31.5663).. controls (-0.449, 31.5454) and 
  (-0.4977, 31.5105) .. (-0.5151, 31.4584).. controls (-0.5151, 31.4584) and 
  (-0.4577, 31.6343) .. (-0.5151, 31.7978).. controls (-0.5151, 31.7978) and 
  (-0.536, 31.6394) .. (-0.6668, 31.6079).. controls (-0.7975, 31.5767) and 
  (-0.8496, 31.5489) .. (-0.8739, 31.5298) -- (-0.8324, 31.7113).. controls 
  (-0.8324, 31.7113) and (-0.7988, 31.7201) .. (-0.9633, 31.9135).. controls 
  (-0.9633, 31.9135) and (-0.8316, 32.0452) .. (-0.8199, 32.1788).. controls 
  (-0.8083, 32.3122) and (-0.7736, 32.4032) .. (-0.7078, 32.4709).. controls 
  (-0.7078, 32.4709) and (-0.7869, 32.4921) .. (-0.8742, 32.3955).. controls 
  (-0.9612, 32.2987) and (-1.0078, 32.291) .. (-1.0057, 32.3278).. controls 
  (-1.0038, 32.3646) and (-0.9051, 32.5056) .. (-0.9747, 32.7128).. controls 
  (-0.9747, 32.7128) and (-1.029, 32.8347) .. (-0.9768, 32.9025).. controls 
  (-0.9768, 32.9025) and (-1.0483, 32.8617) .. (-1.0755, 32.7517).. controls 
  (-1.1025, 32.6411) and (-1.1819, 32.6395) .. (-1.1819, 32.6395).. controls 
  (-1.1819, 32.6395) and (-1.1004, 32.7477) .. (-1.1411, 32.9334).. controls 
  (-1.1819, 33.1189) and (-1.1761, 33.148) .. (-1.1568, 33.1753).. controls 
  (-1.1568, 33.1753) and (-1.2205, 33.1189) .. (-1.2554, 33.0319).. controls 
  (-1.2901, 32.9448) and (-1.3772, 32.9334) .. (-1.3848, 32.9874).. controls 
  (-1.3848, 32.9874) and (-1.325, 33.2041) .. (-1.4198, 33.3472).. controls 
  (-1.4198, 33.3472) and (-1.4158, 33.0223) .. (-1.6656, 33.2507).. controls 
  (-1.6656, 33.2507) and (-1.6947, 33.2874) .. (-1.71, 33.3938).. controls 
  (-1.7253, 33.5002) and (-1.7933, 33.4674) .. (-1.8378, 33.4983).. controls 
  (-1.8822, 33.5293) and (-1.8918, 33.5391) .. (-1.9674, 33.537).. controls 
  (-2.0428, 33.5348) and (-2.1085, 33.51) .. (-2.1085, 33.51).. controls 
  (-2.1085, 33.51) and (-2.1124, 33.5621) .. (-2.2323, 33.537).. controls 
  (-2.3524, 33.5118) and (-2.3696, 33.5216) .. (-2.3696, 33.5216).. controls 
  (-2.3696, 33.5216) and (-2.426, 33.5176) .. (-2.4453, 33.4732).. controls 
  (-2.4646, 33.4287) and (-2.5149, 33.4711) .. (-2.5323, 33.4229).. controls 
  (-2.5498, 33.3745) and (-2.6813, 33.3883) .. (-2.6773, 33.3126).. controls 
  (-2.6736, 33.2369) and (-2.6427, 33.1983) .. (-2.5498, 33.1557).. controls 
  (-2.4569, 33.1134) and (-2.3252, 33.0628) .. (-2.2577, 32.9969).. controls 
  (-2.19, 32.9313) and (-2.1201, 32.7437) .. (-2.1201, 32.7437).. controls 
  (-2.1201, 32.7437) and (-2.0079, 32.4225) .. (-1.9886, 32.2757).. controls 
  (-1.9693, 32.1283) and (-1.8997, 31.5319) .. (-1.9304, 31.4272).. controls 
  (-1.9608, 31.3224) and (-2.0992, 31.0922) .. (-2.0992, 31.0922) -- (-2.4315, 
  31.266).. controls (-2.4315, 31.266) and (-2.7765, 31.3991) .. (-2.9147, 
  31.307).. controls (-3.0525, 31.2152) and (-3.0782, 31.1459) .. (-3.1115, 
  31.1459).. controls (-3.1446, 31.1459) and (-3.2443, 31.2152) .. (-3.5232, 
  31.1716).. controls (-3.5232, 31.1716) and (-3.646, 31.1382) .. (-3.7071, 
  31.1589).. controls (-3.7071, 31.1589) and (-3.633, 31.1181) .. (-3.5486, 
  31.0694).. controls (-3.4642, 31.0208) and (-3.4158, 30.9046) .. (-3.4158, 
  30.9046).. controls (-3.4158, 30.9046) and (-3.5819, 30.9798) .. (-3.7581, 
  30.8673).. controls (-3.9349, 30.7549) and (-3.973, 30.7321) .. (-4.0754, 
  30.7525).. controls (-4.0754, 30.7525) and (-4.064, 30.712) .. (-3.9113, 
  30.6795).. controls (-3.7587, 30.6464) and (-3.6817, 30.4953) .. (-3.6259, 
  30.4807).. controls (-3.6259, 30.4807) and (-3.8021, 30.463) .. (-3.9301, 
  30.3966).. controls (-4.0582, 30.3299) and (-4.1108, 30.2913) .. (-4.1682, 
  30.2958).. controls (-4.1682, 30.2958) and (-4.1383, 30.2432) .. (-4.0058, 
  30.2318).. controls (-3.873, 30.2204) and (-3.7835, 30.1357) .. (-3.7904, 
  30.0415).. controls (-3.7973, 29.9481) and (-3.8682, 29.818) .. (-3.8682, 
  29.818).. controls (-3.8682, 29.818) and (-3.8637, 29.7992) .. (-3.9349, 
  29.7627).. controls (-4.0058, 29.7259) and (-4.0468, 29.728) .. (-4.1452, 
  29.6044).. controls (-4.1452, 29.6044) and (-4.2926, 29.5944) .. (-4.3005, 
  29.4915).. controls (-4.3085, 29.3883) and (-4.2077, 29.334) .. (-4.2077, 
  29.334) -- (-4.0674, 29.3965).. controls (-4.0436, 29.3941) and (-4.0915, 
  29.2965) .. (-4.169, 29.2401).. controls (-4.2466, 29.1832) and (-4.2519, 
  29.0962) .. (-4.2082, 29.0726).. controls (-4.1648, 29.0494) and (-4.1513, 
  29.0242) .. (-4.1513, 29.0242).. controls (-4.1513, 29.0242) and (-4.0775, 
  28.9755) .. (-4.0357, 29.0308).. controls (-3.9939, 29.0861) and (-3.9367, 
  29.2002) .. (-3.9217, 29.2137).. controls (-3.9066, 29.2269) and (-3.9201, 
  29.1131) .. (-3.9351, 29.0827).. controls (-3.9502, 29.0525) and (-4.0156, 
  28.9234) .. (-3.9484, 28.8967).. controls (-3.9187, 28.8848) and (-3.9015, 
  28.8858) .. (-3.8886, 28.8866).. controls (-3.8722, 28.888) and (-3.8627, 
  28.889) .. (-3.8431, 28.8649).. controls (-3.8431, 28.8649) and (-3.7693, 
  28.843) .. (-3.7573, 28.9353).. controls (-3.7457, 29.0274) and (-3.7441, 
  29.0742) .. (-3.7357, 29.0843).. controls (-3.7357, 29.0843) and (-3.7391, 
  28.9369) .. (-3.7073, 28.9202).. controls (-3.6896, 28.911) and (-3.6745, 
  28.9202) .. (-3.661, 28.9292).. controls (-3.6499, 28.9369) and (-3.6399, 
  28.9443) .. (-3.6301, 28.9419) -- (-3.5512, 28.9136).. controls (-3.538, 
  28.9036) and (-3.4809, 28.9454) .. (-3.4877, 29.0324).. controls (-3.4944, 
  29.1197) and (-3.5211, 29.2586) .. (-3.4978, 29.3325).. controls (-3.4742, 
  29.406) and (-3.4557, 29.5539) .. (-3.2597, 29.7849).. controls (-3.0636, 
  30.0164) and (-2.7533, 30.1722) .. (-2.6858, 30.2011).. controls (-2.6186, 
  30.2297) and (-0.7591, 30.0251) .. (-0.7591, 30.0251) -- (-0.2006, 30.0013).. 
  controls (-0.2006, 30.0013) and (-0.0754, 29.9582) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.9025, 153.0404)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.132, 29.9865) .. (0.0788, 30.1201).. controls (0.0788, 30.1201) and 
  (-0.036, 30.1281) .. (-0.0892, 30.1897).. controls (-0.0892, 30.1897) and 
  (-0.1209, 30.0945) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.8923, 153.013)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0572, 30.0466)
   and (-0.0741, 30.0918) .. (-0.0781, 30.1222).. controls (-0.0312, 30.0918) 
  and (0.0275, 30.0812) .. (0.0545, 30.0775) -- (0.055, 30.0196) -- (0.0, 
  30.0)(-0.1064, 30.2117) -- (-0.1188, 30.1746).. controls (-0.1204, 30.1701) 
  and (-0.1537, 30.0635) .. (-0.022, 29.9606) -- (-0.0169, 29.9569) -- (-0.0103,
   29.9561) -- (0.0013, 29.9553).. controls (0.0254, 29.9553) and (0.0688, 
  29.9606) .. (0.0918, 29.9944).. controls (0.1103, 30.0217) and (0.1101, 
  30.0595) .. (0.0913, 30.1064) -- (0.086, 30.1196) -- (0.0722, 30.1204).. 
  controls (0.0712, 30.1207) and (-0.0341, 30.1286) .. (-0.0807, 30.182) -- 
  (-0.1064, 30.2117);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.6389, 152.7801)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0468, 29.8386) .. (-0.1, 29.904).. controls (-0.1, 29.904) and (-0.1868, 
  29.9825) .. (-0.1334, 30.0611).. controls (-0.1334, 30.0611) and (-0.0815, 
  29.9638) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.7484, 152.8767)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0101, 30.0101)
   and (-0.046, 30.0492) .. (-0.0402, 30.0931).. controls (-0.0172, 30.068) and 
  (0.0235, 30.04) .. (0.0706, 30.0489) -- (0.0651, 29.995) -- (0.0463, 29.9878) 
  -- (0.0, 30.0)(-0.0437, 30.1818) -- (-0.0643, 30.1511).. controls (-0.1154, 
  30.0762) and (-0.0624, 29.9966) .. (-0.0275, 29.9645) -- (-0.0217, 29.9608).. 
  controls (0.005, 29.9492) and (0.027, 29.9434) .. (0.0463, 29.9434).. controls
   (0.0757, 29.9434) and (0.0921, 29.9569) .. (0.1005, 29.9685).. controls 
  (0.1296, 30.0069) and (0.1111, 30.0757) .. (0.109, 30.0833) -- (0.1019, 
  30.108) -- (0.0786, 30.0974) -- (0.0516, 30.0915).. controls (0.0058, 30.0915)
   and (-0.0259, 30.1484) .. (-0.0265, 30.1492) -- (-0.0437, 30.1818);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.4349, 152.7543)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0093, 29.8373) .. (-0.1225, 29.954).. controls (-0.1225, 29.954) and 
  (-0.1582, 29.9921) .. (-0.1331, 30.0868).. controls (-0.1331, 30.0868) and 
  (-0.0722, 30.0312) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.5695, 152.7907)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (0.0003, 30.0) and
   (-0.0167, 30.0225) .. (-0.0106, 30.0751).. controls (0.0122, 30.0574) and 
  (0.0466, 30.0336) .. (0.0852, 30.0148) -- (0.072, 29.9672) -- (0.0627, 
  29.9632).. controls (0.0548, 29.9632) and (0.036, 29.9683) .. (0.0, 
  30.0)(-0.0376, 30.1574) -- (-0.0471, 30.122).. controls (-0.0743, 30.018) and 
  (-0.0357, 29.9727) .. (-0.0312, 29.9683).. controls (0.0304, 29.9135) and 
  (0.0759, 29.9063) .. (0.1045, 29.9368).. controls (0.1328, 29.9664) and 
  (0.1302, 30.0241) .. (0.1299, 30.0304) -- (0.1291, 30.0442) -- (0.1164, 
  30.0495).. controls (0.0484, 30.0791) and (-0.0098, 30.132) .. (-0.0103, 
  30.1326) -- (-0.0376, 30.1574);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.1071, 152.7378)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0069, 29.8598) .. (-0.1251, 29.9315).. controls (-0.1251, 29.9315) and 
  (-0.1857, 30.0209) .. (-0.1357, 30.1042).. controls (-0.1357, 30.1042) and 
  (-0.1066, 30.004) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.2434, 152.8026)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0077, 30.013) 
  and (-0.0294, 30.0542) .. (-0.023, 30.1005).. controls (-0.0016, 30.0709) and 
  (0.0333, 30.0413) .. (0.0836, 30.0323).. controls (0.0791, 30.0124) and 
  (0.0683, 29.9852) .. (0.0431, 29.9852) -- (0.0, 30.0)(-0.0196, 30.2106) -- 
  (-0.0455, 30.1675).. controls (-0.1024, 30.0733) and (-0.0373, 29.9751) .. 
  (-0.0344, 29.9712) -- (-0.0278, 29.9643).. controls (-0.0013, 29.9487) and 
  (0.0217, 29.9405) .. (0.0431, 29.9405).. controls (0.1087, 29.9405) and 
  (0.1296, 30.013) .. (0.1315, 30.0508) -- (0.1326, 30.0733) -- (0.1098, 
  30.0743).. controls (0.0212, 30.0775) and (-0.0042, 30.1588) .. (-0.0053, 
  30.1622) -- (-0.0196, 30.2106);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.0051, 159.0249)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.2974, 30.0654) .. (0.0032, 30.1617).. controls (0.0032, 30.1617) and 
  (0.1011, 30.1844) .. (0.2209, 30.2432).. controls (0.3408, 30.3019) and 
  (0.5255, 30.3638) .. (0.607, 30.3866).. controls (0.6884, 30.4096) and 
  (0.8723, 30.4884) .. (1.1351, 30.4024).. controls (1.3978, 30.3167) and 
  (1.478, 30.2844) .. (1.5034, 30.2765).. controls (1.5285, 30.2688) and 
  (1.7206, 30.1842) .. (1.8402, 30.2752) -- (1.8767, 30.2969).. controls 
  (1.8767, 30.2969) and (1.8404, 30.214) .. (1.7121, 30.1468).. controls 
  (1.5838, 30.0791) and (1.5428, 30.0519) .. (1.4618, 30.0484).. controls 
  (1.4618, 30.0484) and (1.5671, 29.9947) .. (1.6404, 29.9167).. controls 
  (1.7137, 29.8383) and (1.7912, 29.741) .. (1.8613, 29.7143).. controls 
  (1.9312, 29.687) and (1.9815, 29.6817) .. (2.0735, 29.6775).. controls 
  (2.1651, 29.6735) and (2.3392, 29.6219) .. (2.4495, 29.519).. controls 
  (2.4495, 29.519) and (2.4262, 29.524) .. (2.2307, 29.5325).. controls (2.0365,
   29.5412) and (1.886, 29.4362) .. (1.7806, 29.4367).. controls (1.6753, 
  29.4372) and (1.5981, 29.4012) .. (1.2914, 29.5968) -- (1.1345, 29.6751).. 
  controls (1.1345, 29.6751) and (1.1954, 29.6119) .. (1.2084, 29.5089).. 
  controls (1.2216, 29.4063) and (1.2242, 29.2735) .. (1.2242, 29.2735).. 
  controls (1.2242, 29.2735) and (1.1732, 29.4481) .. (0.97, 29.5531).. controls
   (0.97, 29.5531) and (0.8483, 29.6119) .. (0.7533, 29.6113).. controls 
  (0.6578, 29.6113) and (0.5112, 29.6605) .. (0.4765, 29.6759).. controls 
  (0.4416, 29.6915) and (0.3418, 29.7277) .. (0.25, 29.8238).. controls (0.1582,
   29.9198) and (0.0325, 29.9881) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.2231, 157.5072)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0) -- (1.4899, 29.6838).. 
  controls (1.4899, 29.6838) and (1.1755, 29.8206) .. (1.3166, 30.1654) -- 
  (1.4843, 30.3326).. controls (1.4843, 30.3326) and (1.502, 30.3119) .. 
  (1.2459, 30.294).. controls (1.2459, 30.294) and (0.9919, 30.3067) .. (0.9258,
   30.0172).. controls (0.9258, 30.0172) and (0.8599, 30.1302) .. (0.6382, 
  30.2408).. controls (0.5882, 30.2659) and (0.5323, 30.2945) .. (0.4667, 
  30.3156).. controls (0.1085, 30.4315) and (0.277, 30.3479) .. (0.277, 
  30.3479).. controls (0.277, 30.3479) and (0.3609, 30.304) .. (0.4096, 
  30.1527).. controls (0.4096, 30.1527) and (0.4421, 30.0558) .. (0.4392, 
  30.0238).. controls (0.4392, 30.0238) and (0.3212, 30.0283) .. (0.2381, 
  30.1294).. controls (0.2381, 30.1294) and (0.186, 30.1804) .. (0.0815, 
  30.2299).. controls (-0.023, 30.2797) and (-0.0796, 30.3313) .. (-0.2783, 
  30.2778) -- (-0.1005, 30.2162).. controls (-0.1005, 30.2162) and (0.0757, 
  30.0786) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.2138, 156.4694)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2736, 29.8529) .. (0.3053, 29.8121).. controls (0.3053, 29.8121) and 
  (0.6054, 29.9362) .. (0.5117, 30.2871).. controls (0.5117, 30.2871) and 
  (0.5178, 30.1852) .. (0.3831, 30.1265).. controls (0.254, 30.0706) and 
  (0.2807, 30.1651) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.114, 156.3232)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0) -- (-0.6932, 29.9902).. 
  controls (-0.6932, 29.9902) and (-0.6506, 30.1924) .. (-0.4469, 30.3106).. 
  controls (-0.4469, 30.3106) and (-0.3061, 30.3617) .. (-0.1572, 30.3003).. 
  controls (-0.1572, 30.3003) and (-0.282, 30.3355) .. (-0.3093, 30.1283).. 
  controls (-0.3093, 30.1283) and (-0.2437, 30.2934) .. (0.3495, 30.2101).. 
  controls (0.3495, 30.2101) and (0.14, 30.1442) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.6556, 155.0688)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (1.0239, 29.6817) .. (1.2554, 29.7508) -- (1.4028, 29.8746).. controls 
  (1.4028, 29.8746) and (1.2978, 29.8693) .. (1.1814, 29.8743).. controls 
  (1.0726, 29.8791) and (0.8983, 29.8746) .. (0.8752, 29.8574).. controls 
  (0.8752, 29.8574) and (0.934, 29.9907) .. (1.0544, 30.0574).. controls 
  (1.0544, 30.0574) and (0.9766, 30.0516) .. (0.8662, 30.0759).. controls 
  (0.7557, 30.1003) and (0.6654, 30.05) .. (0.6474, 30.0198).. controls (0.6474,
   30.0198) and (0.74, 30.1688) .. (0.8054, 30.2625).. controls (0.8054, 
  30.2625) and (0.5038, 30.2127) .. (0.4482, 30.1865).. controls (0.3924, 
  30.1606) and (0.3458, 30.1487) .. (0.3315, 30.1106).. controls (0.3315, 
  30.1106) and (0.3707, 30.2746) .. (0.3564, 30.3672) -- (0.3426, 30.4585).. 
  controls (0.3426, 30.4585) and (0.3093, 30.2889) .. (0.2273, 30.2614).. 
  controls (0.1453, 30.2344) and (0.0357, 30.2122) .. (0.0, 30.1797).. controls 
  (0.0, 30.1797) and (-0.0532, 30.0413) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.8021, 154.3302)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.4106, 30.5231) .. (-0.63, 31.2279) -- (-0.6429, 31.2565).. controls 
  (-0.6429, 31.2565) and (-0.5181, 31.1589) .. (-0.467, 31.2816).. controls 
  (-0.467, 31.2816) and (-0.4358, 31.3896) .. (-0.4448, 31.4174).. controls 
  (-0.4448, 31.4174) and (-0.368, 31.3028) .. (-0.4194, 31.0422).. controls 
  (-0.4194, 31.0422) and (-0.3831, 30.9551) .. (-0.2942, 31.0448).. controls 
  (-0.2942, 31.0448) and (-0.2484, 31.2046) .. (-0.1815, 31.2454).. controls 
  (-0.1815, 31.2454) and (-0.1961, 31.1396) .. (-0.177, 30.9824).. controls 
  (-0.1524, 30.7776) and (-0.2291, 30.7022) .. (-0.2291, 30.7022).. controls 
  (-0.2291, 30.7022) and (-0.1183, 30.6903) .. (-0.0826, 30.8382).. controls 
  (-0.0826, 30.8382) and (-0.059, 30.9356) .. (-0.0138, 30.9549).. controls 
  (-0.0138, 30.9549) and (-0.045, 30.9136) .. (-0.0066, 30.7609).. controls 
  (0.0315, 30.6093) and (-0.0307, 30.3979) .. (-0.0307, 30.3979).. controls 
  (-0.0307, 30.3979) and (-0.0283, 30.3416) .. (0.0611, 30.4096).. controls 
  (0.1326, 30.4636) and (0.1574, 30.5387) .. (0.2437, 30.5265).. controls 
  (0.2437, 30.5265) and (0.1651, 30.458) .. (0.1505, 30.3053).. controls 
  (0.1357, 30.1529) and (0.0743, 30.0693) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.1087, 154.239)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0) -- (0.0558, 31.0348).. 
  controls (0.0558, 31.0348) and (0.1334, 31.1401) .. (0.2643, 31.1681).. 
  controls (0.2643, 31.1681) and (0.199, 31.1454) .. (0.2072, 31.0208).. 
  controls (0.2154, 30.8964) and (0.2043, 30.8083) .. (0.1148, 30.748).. 
  controls (0.1148, 30.748) and (0.2315, 30.6932) .. (0.3313, 30.8147).. 
  controls (0.3313, 30.8147) and (0.3664, 30.8686) .. (0.4397, 30.917).. 
  controls (0.4397, 30.917) and (0.399, 30.861) .. (0.3884, 30.6638).. controls 
  (0.3781, 30.4667) and (0.2368, 30.4255) .. (0.1736, 30.4043).. controls 
  (0.1736, 30.4043) and (0.2953, 30.2799) .. (0.4326, 30.3561).. controls 
  (0.5694, 30.4323) and (0.5943, 30.4389) .. (0.6297, 30.4196).. controls 
  (0.6297, 30.4196) and (0.5326, 30.426) .. (0.4937, 30.2897).. controls 
  (0.4548, 30.1527) and (0.3736, 30.0738) .. (0.1921, 30.0778).. controls 
  (0.1921, 30.0778) and (0.0333, 30.0447) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.9803, 153.5973)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.3567, 30.3575) .. (-0.5345, 30.4456).. controls (-0.5345, 30.4456) and 
  (-0.5374, 30.4392) .. (-0.517, 30.5212).. controls (-0.4966, 30.6027) and 
  (-0.4956, 30.63) .. (-0.4956, 30.63).. controls (-0.4956, 30.63) and (-0.3881,
   30.5906) .. (-0.3971, 30.4654).. controls (-0.3971, 30.4654) and (-0.2656, 
  30.5617) .. (-0.3162, 30.7059).. controls (-0.3162, 30.7059) and (-0.0844, 
  30.5366) .. (-0.1659, 30.2783).. controls (-0.1659, 30.2783) and (-0.1212, 
  30.313) .. (-0.037, 30.5159) -- (0.0468, 30.313).. controls (0.0468, 30.313) 
  and (0.081, 30.1548) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.3667, 156.858)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0) -- (0.7546, 31.2634).. 
  controls (0.7546, 31.2634) and (0.7408, 31.2062) .. (0.6276, 31.2496).. 
  controls (0.6276, 31.2496) and (0.4591, 31.2827) .. (0.3215, 31.2525).. 
  controls (0.1839, 31.2224) and (0.1648, 31.2412) .. (0.1648, 31.2412) -- 
  (0.3358, 31.1509).. controls (0.3358, 31.1509) and (0.4305, 31.0144) .. 
  (0.4344, 30.9663).. controls (0.4344, 30.9663) and (0.245, 31.0644) .. 
  (0.1114, 30.9837).. controls (-0.0222, 30.9025) and (-0.1315, 30.7945) .. 
  (-0.2188, 30.8398).. controls (-0.2188, 30.8398) and (-0.2249, 30.8147) .. 
  (-0.1246, 30.7982).. controls (-0.0241, 30.7813) and (0.0878, 30.7109) .. 
  (0.1281, 30.6599).. controls (0.1683, 30.6085) and (0.2008, 30.5728) .. 
  (0.2008, 30.5728).. controls (0.2008, 30.5728) and (0.0582, 30.5408) .. 
  (-0.0029, 30.5101).. controls (-0.0029, 30.5101) and (-0.0939, 30.4786) .. 
  (-0.1752, 30.4313).. controls (-0.2566, 30.3836) and (-0.2889, 30.3866) .. 
  (-0.3178, 30.385).. controls (-0.3178, 30.385) and (-0.263, 30.3479) .. 
  (-0.1683, 30.3323).. controls (-0.0736, 30.317) and (-0.0093, 30.3106) .. 
  (0.0463, 30.2027).. controls (0.0463, 30.2027) and (0.0582, 30.1138) .. (-0.0,
   30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5585, 159.7208)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.063, 30.1468) .. (-0.3228, 30.2021).. controls (-0.5826, 30.2572) and 
  (-0.69, 30.1939) .. (-1.0364, 30.5667).. controls (-1.0364, 30.5667) and 
  (-0.721, 30.3342) .. (-0.4958, 30.3175).. controls (-0.2466, 30.2992) and 
  (-0.063, 30.1468) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.6441, 159.6599)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (-0.1138, 
  29.9577) and (-0.2426, 29.968) .. (-0.3575, 30.0082).. controls (-0.472, 
  30.0487) and (-0.5747, 30.1172) .. (-0.6712, 30.1913).. controls (-0.7371, 
  30.2418) and (-0.7927, 30.2625) .. (-0.8731, 30.2775).. controls (-0.9575, 
  30.2932) and (-1.043, 30.3064) .. (-1.129, 30.3117).. controls (-1.3018, 
  30.3225) and (-1.5293, 30.3903) .. (-1.7492, 30.5601).. controls (-1.4891, 
  30.4657) and (-1.2118, 30.3778) .. (-0.9358, 30.3493).. controls (-0.8239, 
  30.3379) and (-0.7231, 30.341) .. (-0.6265, 30.2736).. controls (-0.5644, 
  30.2302) and (-0.5199, 30.1683) .. (-0.458, 30.1236).. controls (-0.3273, 
  30.0283) and (-0.1611, 29.9817) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.8954, 158.7905)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.2564, 30.0429) .. (-0.5675, 30.1783).. controls (-0.6787, 30.2267) and 
  (-0.9917, 30.2749) .. (-1.2954, 30.0564).. controls (-1.2954, 30.0564) and 
  (-1.0779, 30.191) .. (-0.7244, 30.1257).. controls (-0.3709, 30.0598) and 
  (-0.3297, 29.9508) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.2697, 159.5009)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.3638, 29.8928) .. (-0.7773, 30.259).. controls (-0.7773, 30.259) and 
  (-0.5993, 29.9765) .. (-0.3887, 29.95).. controls (-0.1778, 29.9241) and 
  (-0.1045, 29.932) .. (-0.1045, 29.932).. controls (-0.1045, 29.932) and 
  (-0.3911, 29.8577) .. (-0.6204, 29.9685).. controls (-0.8496, 30.0794) and 
  (-0.8305, 30.2514) .. (-1.2983, 30.259).. controls (-1.2983, 30.259) and 
  (-1.7145, 30.3194) .. (-2.0053, 30.4477).. controls (-1.9227, 30.4318) and 
  (-1.8391, 30.421) .. (-1.7558, 30.4122).. controls (-1.6158, 30.3977) and 
  (-1.4571, 30.3802) .. (-1.3187, 30.4141).. controls (-1.2401, 30.4337) and 
  (-1.1695, 30.4323) .. (-1.0877, 30.4344).. controls (-1.002, 30.436) and 
  (-0.9149, 30.4199) .. (-0.8329, 30.395).. controls (-0.7414, 30.3678) and 
  (-0.6429, 30.3323) .. (-0.5765, 30.259).. controls (-0.5144, 30.19) and 
  (-0.4704, 30.1201) .. (-0.3839, 30.0759).. controls (-0.3381, 30.0524) and 
  (-0.2881, 30.0376) .. (-0.2379, 30.0265).. controls (-0.2029, 30.0185) and 
  (-0.1672, 30.0132) .. (-0.1318, 30.009).. controls (-0.0953, 30.005) and 
  (-0.0349, 29.9897) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.6505, 158.7177)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.4096, 30.136) .. (-0.7152, 29.9587).. controls (-0.7152, 29.9587) and 
  (-0.8604, 29.8664) .. (-0.989, 29.8955).. controls (-0.989, 29.8955) and 
  (-0.9091, 29.8378) .. (-0.725, 29.8473).. controls (-0.5405, 29.8571) and 
  (-0.3686, 30.0267) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.4869, 158.9449)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0646, 29.9947)
   and (0.1294, 29.9923) .. (0.1939, 29.9913).. controls (0.2704, 29.9902) and 
  (0.3493, 29.9849) .. (0.4241, 30.0042).. controls (0.4852, 30.0198) and 
  (0.5305, 30.0532) .. (0.5948, 30.0598).. controls (0.7019, 30.0706) and 
  (0.9398, 30.0407) .. (0.9454, 30.0386).. controls (0.807, 30.09) and (0.6554, 
  30.1381) .. (0.5061, 30.1193).. controls (0.4696, 30.1148) and (0.4334, 
  30.1053) .. (0.3995, 30.0908).. controls (0.3704, 30.0781) and (0.3466, 
  30.0572) .. (0.3191, 30.0434).. controls (0.2902, 30.0294) and (0.2535, 
  30.0259) .. (0.2225, 30.0212).. controls (0.149, 30.0101) and (0.0743, 
  30.0048) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.6806, 156.2971)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (-0.1717, 30.0).. controls
   (-0.1717, 30.0) and (-0.1185, 30.1752) .. (0.0177, 30.2424).. controls 
  (0.0177, 30.2424) and (-0.086, 30.1312) .. (-0.077, 30.0656).. controls 
  (-0.077, 30.0656) and (0.0445, 30.2394) .. (0.1339, 30.2704).. controls 
  (0.1339, 30.2704) and (-0.005, 30.1386) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5136, 156.3355)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0783, 30.0).. controls 
  (0.0783, 30.0) and (0.1416, 30.1389) .. (0.2879, 30.1654).. controls (0.2879, 
  30.1654) and (0.091, 30.1969) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.2923, 156.3355)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0833, 30.0).. controls 
  (0.0833, 30.0) and (0.1588, 30.1508) .. (0.2855, 30.1675).. controls (0.2855, 
  30.1675) and (0.1363, 30.1897) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.1308, 156.525)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0656, 29.9847) .. (0.0833, 29.9595).. controls (0.0833, 29.9595) and 
  (0.2373, 30.1111) .. (0.3233, 30.1185).. controls (0.3233, 30.1185) and 
  (0.081, 30.0783) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-45.9452, 156.642)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0738, 29.9791).. 
  controls (0.0738, 29.9791) and (0.2336, 30.1773) .. (0.232, 30.2564).. 
  controls (0.232, 30.2564) and (0.104, 30.0767) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.9909, 157.5466)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.1209, 29.9788).. 
  controls (0.1209, 29.9788) and (-0.0122, 30.2074) .. (-0.227, 30.2381).. 
  controls (-0.227, 30.2381) and (-0.0069, 30.0926) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.5084, 157.6385)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.1294, 29.9714).. 
  controls (0.1294, 29.9714) and (0.0818, 30.177) .. (-0.1296, 30.3299).. 
  controls (-0.1296, 30.3299) and (0.028, 30.0847) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.2683, 157.6924)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0153, 30.2521) .. (-0.2447, 30.3617).. controls (-0.2447, 30.3617) and 
  (0.0971, 30.2164) .. (0.1021, 29.9844) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5539, 157.8482)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.172, 30.2212) .. (-0.0706, 30.3953).. controls (-0.0706, 30.3953) and 
  (-0.1707, 30.3339) .. (-0.1318, 30.1373).. controls (-0.1318, 30.1373) and 
  (-0.3077, 30.322) .. (-0.0701, 30.4559).. controls (-0.0701, 30.4559) and 
  (-0.2559, 30.4501) .. (-0.2672, 30.1773).. controls (-0.2672, 30.1773) and 
  (-0.3797, 30.3908) .. (-0.1069, 30.5091).. controls (-0.1069, 30.5091) and 
  (-0.4307, 30.4495) .. (-0.3291, 30.0646) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.8719, 154.2406)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1389, 30.0024) .. (0.1577, 30.1373).. controls (0.1577, 30.1373) and 
  (0.1201, 30.0667) .. (0.0124, 30.0688).. controls (0.0124, 30.0688) and 
  (0.1508, 30.0945) .. (0.173, 30.2842).. controls (0.173, 30.2842) and (0.1191,
   30.1423) .. (-0.0, 30.1646).. controls (-0.0, 30.1646) and (0.149, 30.1849) 
  .. (0.173, 30.3471).. controls (0.173, 30.3471) and (0.1032, 30.1357) .. 
  (-0.1516, 30.2672) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.0968, 153.8504)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1598, 29.9278) .. (0.1908, 30.1852).. controls (0.1908, 30.1852) and 
  (0.1315, 30.0407) .. (0.0519, 30.0646).. controls (0.0519, 30.0646) and 
  (0.1955, 30.1434) .. (0.2037, 30.3278).. controls (0.2037, 30.3278) and 
  (0.1828, 30.1566) .. (0.0283, 30.164).. controls (0.0283, 30.164) and (0.1773,
   30.2032) .. (0.1685, 30.377).. controls (0.1685, 30.377) and (0.1349, 
  30.1654) .. (-0.1445, 30.2635) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.3108, 153.4465)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2278, 29.9407) .. (0.2008, 30.2463).. controls (0.2008, 30.2463) and 
  (0.1585, 30.0812) .. (0.0489, 30.0791).. controls (0.0489, 30.0791) and 
  (0.2008, 30.1561) .. (0.1757, 30.3328).. controls (0.1757, 30.3328) and 
  (0.1566, 30.1733) .. (-0.0259, 30.1865).. controls (-0.0259, 30.1865) and 
  (0.1389, 30.2228) .. (0.1585, 30.354).. controls (0.1585, 30.354) and (0.1336,
   30.231) .. (-0.0876, 30.2424) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.4437, 153.0692)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0963, 30.0487) .. (0.0857, 30.1765).. controls (0.0857, 30.1765) and 
  (0.0527, 30.0566) .. (-0.0302, 30.0606) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.4963, 152.9587)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.087, 29.9857) .. (0.1132, 30.1244).. controls (0.1132, 30.1244) and 
  (0.0646, 30.0167) .. (-0.0265, 30.0616) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.5426, 152.8486)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.095, 29.9762) .. (0.1254, 30.0423).. controls (0.1254, 30.0423) and 
  (0.0407, 29.9971) .. (-0.0119, 30.0294) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.6484, 153.0407)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0886, 29.9511).. 
  controls (0.0886, 29.9511) and (0.0974, 30.0114) .. (0.0709, 30.0849).. 
  controls (0.0709, 30.0849) and (0.0736, 30.036) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.3653, 153.2445)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0434, 29.9643).. 
  controls (0.0434, 29.9643) and (0.1228, 30.1072) .. (0.0902, 30.2363).. 
  controls (0.0902, 30.2363) and (0.0717, 30.077) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.4556, 153.1925)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0548, 29.964).. 
  controls (0.0548, 29.964) and (0.1339, 30.1283) .. (0.0868, 30.236).. controls
   (0.0868, 30.236) and (0.0773, 30.0754) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.2211, 153.3639)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.063, 29.9529).. 
  controls (0.063, 29.9529) and (0.1683, 30.0585) .. (0.1625, 30.1566).. 
  controls (0.1625, 30.1566) and (0.1085, 30.032) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.11, 153.4545)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0603, 29.959).. 
  controls (0.0603, 29.959) and (0.1042, 30.0759) .. (0.0923, 30.1521).. 
  controls (0.0923, 30.1521) and (0.082, 30.0511) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.0978, 154.1417)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0098, 30.3093).. 
  controls (0.0098, 30.3093) and (0.2797, 30.1304) .. (0.3969, 30.2397).. 
  controls (0.3969, 30.2397) and (0.3662, 30.123) .. (0.1183, 30.1294).. 
  controls (0.1183, 30.1294) and (0.3045, 30.0908) .. (0.3807, 30.1373).. 
  controls (0.3807, 30.1373) and (0.2802, 30.0357) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.071, 153.7227)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0, 30.2582).. controls
   (0.0, 30.2582) and (0.2236, 30.2339) .. (0.2958, 30.3477).. controls (0.2958,
   30.3477) and (0.2926, 30.2339) .. (0.0997, 30.208).. controls (0.0997, 
  30.208) and (0.2461, 30.1445) .. (0.3201, 30.3061).. controls (0.3201, 
  30.3061) and (0.2839, 30.1307) .. (0.1016, 30.0585).. controls (0.1016, 
  30.0585) and (0.2461, 30.0791) .. (0.3286, 30.1995).. controls (0.3286, 
  30.1995) and (0.3133, 30.005) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.0641, 153.302)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0, 30.1257).. controls
   (0.0, 30.1257) and (0.0622, 30.2167) .. (0.0984, 30.2717) -- (0.0262, 
  30.1035).. controls (0.0262, 30.1035) and (0.1363, 30.2461) .. (0.1378, 
  30.3043).. controls (0.1378, 30.3043) and (0.1304, 30.0722) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.5838, 155.0443)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0995, 29.9775).. 
  controls (0.0995, 29.9775) and (0.0889, 30.0646) .. (0.1759, 30.1482).. 
  controls (0.263, 30.2318) and (0.2614, 30.2892) .. (0.2614, 30.2892).. 
  controls (0.2614, 30.2892) and (0.1778, 30.1498) .. (0.0836, 30.1185).. 
  controls (-0.0106, 30.087) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.4208, 155.0879)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0699, 29.981).. 
  controls (0.0699, 29.981) and (0.0839, 30.1759) .. (0.1117, 30.2021).. 
  controls (0.1117, 30.2021) and (-0.0037, 30.0767) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.2812, 155.1293)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0791, 29.9762).. 
  controls (0.0791, 29.9762) and (0.1222, 30.2154) .. (0.2974, 30.2352).. 
  controls (0.2974, 30.2352) and (0.1069, 30.2445) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.1744, 155.1802)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.1392, 29.9645).. 
  controls (0.1392, 29.9645) and (0.1511, 30.1127) .. (0.1879, 30.1654).. 
  controls (0.1879, 30.1654) and (0.1016, 30.0781) .. (0.0939, 30.0278).. 
  controls (0.0939, 30.0278) and (0.1363, 30.1942) .. (0.1879, 30.2267).. 
  controls (0.1879, 30.2267) and (0.0582, 30.1532) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.8529, 155.2589)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.1643, 29.959).. 
  controls (0.1643, 29.959) and (0.1664, 30.1159) .. (0.268, 30.164).. controls 
  (0.268, 30.164) and (0.1601, 30.1294) .. (0.1037, 30.0323).. controls (0.1037,
   30.0323) and (0.0566, 30.1294) .. (0.2376, 30.1921).. controls (0.2376, 
  30.1921) and (0.0648, 30.2138) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.3469, 155.3697)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0974, 29.9828).. 
  controls (0.0974, 29.9828) and (0.149, 30.0495) .. (0.2074, 30.0476).. 
  controls (0.2074, 30.0476) and (0.082, 30.054) .. (0.0172, 30.0323).. controls
   (0.0172, 30.0323) and (0.0886, 30.0712) .. (0.1598, 30.0778).. controls 
  (0.1598, 30.0778) and (0.055, 30.1061) .. (-0.1426, 30.0302) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.6977, 155.7587)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.204, 30.3022).. 
  controls (0.204, 30.3022) and (0.1127, 30.3813) .. (-0.0407, 30.3572).. 
  controls (-0.0407, 30.3572) and (0.0672, 30.3477) .. (0.1008, 30.2519).. 
  controls (0.1008, 30.2519) and (-0.0407, 30.3455) .. (-0.2254, 30.3432).. 
  controls (-0.2254, 30.3432) and (-0.0024, 30.2802) .. (0.0503, 30.181).. 
  controls (0.0503, 30.181) and (-0.0632, 30.2699) .. (-0.2061, 30.3022).. 
  controls (-0.2061, 30.3022) and (-0.0095, 30.182) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.8637, 156.0527)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.1069, 30.1969).. 
  controls (0.1069, 30.1969) and (-0.0307, 30.4051) .. (-0.3, 30.2844).. 
  controls (-0.3, 30.2844) and (-0.0537, 30.3109) .. (0.0019, 30.1609).. 
  controls (0.0019, 30.1609) and (-0.2085, 30.3191) .. (-0.4186, 30.1987).. 
  controls (-0.4186, 30.1987) and (-0.1072, 30.2236) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.9047, 156.1536)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.0286, 30.0463) -- 
  (-0.2641, 30.1873).. controls (-0.2641, 30.1873) and (-0.1106, 30.0463) .. 
  (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.2652, 156.7363)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0019, 30.2389) .. (-0.2368, 30.2598).. controls (-0.2368, 30.2598) and 
  (-0.0841, 30.2868) .. (0.09, 30.1569).. controls (0.09, 30.1569) and (-0.0114,
   30.3495) .. (-0.2159, 30.2982).. controls (-0.2159, 30.2982) and (-0.086, 
  30.3918) .. (0.1654, 30.2887).. controls (0.1654, 30.2887) and (0.1127, 
  30.413) .. (-0.1511, 30.3691).. controls (-0.1511, 30.3691) and (0.0534, 
  30.48) .. (0.2484, 30.3977) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.7036, 154.7661)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.014, 29.9595) 
  and (-0.0566, 29.8225) .. (-0.0265, 29.7629) -- (0.0101, 29.732).. controls 
  (0.0191, 29.7293) and (0.9459, 29.4576) .. (1.3425, 29.4576) -- (1.3533, 
  29.4576) -- (1.3526, 29.5243).. controls (0.9829, 29.5185) and (0.0915, 
  29.7778) .. (0.0325, 29.7952).. controls (0.0228, 29.8159) and (0.0368, 
  29.901) .. (0.0632, 29.9786) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.6765, 152.9604)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0431, 29.9492).. 
  controls (-0.037, 29.9442) and (0.5424, 29.4576) .. (0.5749, 29.4285) -- 
  (0.6197, 29.478).. controls (0.5863, 29.5081) and (0.0238, 29.9802) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.0691, 152.8922)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0905, 29.2324)
   and (-0.0616, 28.9321) .. (-0.0606, 28.9197) -- (-0.0029, 28.9258).. controls
   (-0.0032, 28.9284) and (-0.032, 29.2335) .. (0.0574, 29.9931) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.8638, 155.9769)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0045, 29.9907)
   and (-0.1119, 29.7748) .. (-0.1302, 29.7201) -- (-0.14, 29.6904) -- (-0.1085,
   29.691).. controls (-0.1, 29.6912) and (0.7575, 29.71) .. (0.8655, 29.6941) 
  -- (0.8723, 29.7381).. controls (0.7718, 29.7531) and (0.087, 29.7399) .. 
  (-0.0759, 29.7365).. controls (-0.0423, 29.8145) and (0.0389, 29.978) .. 
  (0.0397, 29.9799) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.2535, 156.4453)}]
      \path[fill=ce5ae4a,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.3379, 29.8304) .. (0.3627, 29.7685);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.2346, 156.4076)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0299, 29.9402).. 
  controls (0.1241, 29.8629) and (0.3006, 29.7592) .. (0.3167, 29.7262) -- 
  (0.3786, 29.751).. controls (0.3522, 29.8177) and (0.1048, 29.9473) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.4608, 155.2596)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0611, 29.8799)
   and (-0.7728, 28.6705) .. (-0.7803, 28.6583) -- (-0.7226, 28.6242).. controls
   (-0.6932, 28.6742) and (-0.0024, 29.8476) .. (0.0595, 29.9698) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.9569, 156.5554)}]
      \path[fill=cc98e37,even odd rule] (0.0, 30.0).. controls (0.0651, 30.032) 
  and (0.1622, 30.0392) .. (0.2162, 30.0685).. controls (0.2908, 30.1082) and 
  (0.3588, 30.1606) .. (0.418, 30.2209).. controls (0.5964, 30.403) and (0.6781,
   30.6535) .. (0.6966, 30.9033).. controls (0.7572, 31.7156) and (1.2666, 
  31.7156) .. (1.2666, 31.7156).. controls (1.2666, 31.7156) and (0.8723, 
  31.5785) .. (0.8782, 31.1573).. controls (0.8813, 30.9382) and (0.8771, 
  30.7136) .. (0.8173, 30.5014).. controls (0.7371, 30.2159) and (0.5609, 
  30.0397) .. (0.2754, 29.9627).. controls (0.1889, 29.9394) and (0.096, 
  29.9135) .. (0.0056, 29.9167).. controls (-0.0339, 29.918) and (-0.0773, 
  29.9175) .. (-0.0519, 29.9574) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.6038, 152.3439)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (-0.0071, 29.986) -- 
  (-0.0124, 29.9447) -- (0.0048, 29.8868) -- (0.0233, 29.859) -- (0.0466, 
  29.8336) -- (0.0982, 29.796) -- (0.1455, 29.7695).. controls (0.1744, 29.7553)
   and (0.1963, 29.7494) .. (0.1963, 29.7494).. controls (0.1963, 29.7494) and 
  (0.1852, 29.7693) .. (0.164, 29.7936).. controls (0.1445, 29.818) and (0.1101,
   29.8476) .. (0.0823, 29.8722) -- (0.0437, 29.9122) -- (0.0169, 29.9521).. 
  controls (0.0034, 29.9775) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.8985, 152.3746)}]
      \path[fill=black,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0143, 29.9799) .. (-0.0135, 29.9439) -- (-0.0008, 29.8849) -- (0.0357, 
  29.8267) -- (0.0849, 29.7833) -- (0.131, 29.7524).. controls (0.1588, 29.7357)
   and (0.1804, 29.7277) .. (0.1804, 29.7277).. controls (0.1804, 29.7277) and 
  (0.1709, 29.7486) .. (0.1513, 29.7748) -- (0.1164, 29.8177) -- (0.0754, 
  29.8616).. controls (0.0489, 29.8905) and (0.0283, 29.9225) .. (0.0161, 
  29.95).. controls (0.004, 29.977) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.1978, 152.4041)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (-0.0066, 29.9892) -- 
  (-0.0132, 29.9556) -- (-0.0021, 29.9085) -- (0.0294, 29.864) -- (0.0699, 
  29.8333) -- (0.1074, 29.8129) -- (0.149, 29.7984) -- (0.1267, 29.8365) -- 
  (0.0992, 29.8693) -- (0.0664, 29.9018) -- (0.0161, 29.9627) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.2923, 152.7232)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (-0.0077, 29.9844) -- 
  (-0.0119, 29.9381) -- (0.0093, 29.8749) -- (0.0304, 29.8444) -- (0.0569, 
  29.8172) -- (0.1148, 29.7756) -- (0.168, 29.7463).. controls (0.2, 29.7301) 
  and (0.2241, 29.7232) .. (0.2241, 29.7232).. controls (0.2241, 29.7232) and 
  (0.2106, 29.7444) .. (0.1863, 29.7706).. controls (0.163, 29.7968) and 
  (0.1244, 29.8288) .. (0.0918, 29.8566) -- (0.0476, 29.901) -- (0.0172, 
  29.946).. controls (0.0024, 29.9746) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.6036, 152.7583)}]
      \path[fill=black,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0101, 29.9783) .. (-0.0029, 29.9439) -- (0.0198, 29.8899) -- (0.0656, 
  29.841) -- (0.1204, 29.809) -- (0.1701, 29.7883).. controls (0.1998, 29.7775) 
  and (0.222, 29.7746) .. (0.222, 29.7746) -- (0.1857, 29.8143) -- (0.1447, 
  29.8489) -- (0.0979, 29.8833).. controls (0.0672, 29.9055) and (0.0418, 
  29.9317) .. (0.0251, 29.9556) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.7881, 152.8287)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (-0.0045, 29.9878) -- 
  (-0.0048, 29.954) -- (0.0153, 29.9098) -- (0.0545, 29.8722) -- (0.1003, 
  29.8497) -- (0.1413, 29.8368).. controls (0.1659, 29.8307) and (0.1847, 
  29.8307) .. (0.1847, 29.8307) -- (0.1556, 29.8635) -- (0.1222, 29.8907) -- 
  (0.0839, 29.9161).. controls (0.0595, 29.932) and (0.0378, 29.9495) .. 
  (0.0228, 29.9664) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.5212, 152.3512)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (-0.0042, 29.982) -- 
  (0.0005, 29.9328) -- (0.0336, 29.8698) -- (0.0606, 29.8407) -- (0.0931, 
  29.8161) -- (0.1614, 29.7815) -- (0.2225, 29.7582).. controls (0.259, 29.7457)
   and (0.2855, 29.742) .. (0.2855, 29.742).. controls (0.2855, 29.742) and 
  (0.2675, 29.7619) .. (0.2368, 29.7849) -- (0.1831, 29.8225) -- (0.122, 
  29.8603) -- (0.0677, 29.9013) -- (0.028, 29.9452).. controls (0.0074, 29.9741)
   and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.758, 152.4712)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (-0.0045, 29.9878) -- 
  (-0.0045, 29.954) -- (0.0153, 29.9095) -- (0.0548, 29.8722) -- (0.1003, 
  29.8497) -- (0.1413, 29.8368).. controls (0.1659, 29.8304) and (0.1847, 
  29.8304) .. (0.1847, 29.8304) -- (0.1556, 29.8635) -- (0.1222, 29.8907) -- 
  (0.0839, 29.9161).. controls (0.0595, 29.9317) and (0.0378, 29.9495) .. 
  (0.023, 29.9664) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.5615, 157.8499)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (0.0288, 30.0233) -- 
  (0.0738, 30.0823) -- (0.1029, 30.1495) -- (0.1095, 30.1741) -- (0.1124, 
  30.1842) -- (0.1019, 30.1812) -- (0.0781, 30.1675).. controls (0.0601, 30.154)
   and (0.0418, 30.1326) .. (0.028, 30.1085).. controls (0.0146, 30.0844) and 
  (0.0056, 30.0585) .. (0.0021, 30.0373) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.2652, 158.004)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (0.0183, 30.032).. controls 
  (0.027, 30.0513) and (0.0344, 30.0775) .. (0.0384, 30.1037).. controls 
  (0.0421, 30.1302) and (0.0421, 30.1566) .. (0.0402, 30.177) -- (0.0376, 
  30.2024) -- (0.0365, 30.2125) -- (0.0278, 30.2061) -- (0.0108, 30.1844).. 
  controls (-0.0008, 30.1654) and (-0.0101, 30.1384) .. (-0.014, 30.1111).. 
  controls (-0.0175, 30.0839) and (-0.0164, 30.0564) .. (-0.0116, 30.0352) -- 
  (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.2341, 154.3729)}]
      \path[fill=cc98e37,even odd rule] (0.0, 30.0).. controls (0.0, 30.2077) 
  and (0.0013, 30.4149) .. (0.0064, 30.6231).. controls (0.0087, 30.7207) and 
  (0.0114, 30.8186) .. (0.0177, 30.9163).. controls (0.0209, 30.9649) and 
  (0.0169, 31.0319) .. (0.0386, 31.0771) -- (0.0431, 31.0837).. controls 
  (0.0431, 31.0837) and (-0.0463, 31.3213) .. (-0.0368, 31.3819).. controls 
  (-0.0368, 31.3819) and (-0.1074, 31.292) .. (-0.164, 31.2946).. controls 
  (-0.2204, 31.297) and (-0.4421, 31.2753) .. (-0.4421, 31.2753) -- (-0.3977, 
  31.1049).. controls (-0.3977, 31.1049) and (-0.1722, 31.1245) .. (-0.1117, 
  31.0837).. controls (-0.0511, 31.043) and (-0.082, 30.2434) .. (-0.0995, 
  30.1352).. controls (-0.0503, 30.0992) and (-0.0124, 30.0606) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.0983, 154.2406)}]
      \path[fill=cd39a3e,nonzero rule] (0.0, 30.0).. controls (-0.0743, 29.9632)
   and (-0.1505, 29.9296) .. (-0.2262, 29.8955).. controls (-0.3048, 29.8603) 
  and (-0.3934, 29.8402) .. (-0.4654, 29.7915).. controls (-0.5932, 29.7055) and
   (-0.6707, 29.5648) .. (-0.7131, 29.4198) -- (-0.7525, 29.1896).. controls 
  (-0.7506, 29.1893) and (-0.749, 29.1891) .. (-0.7469, 29.1891) -- (-0.7406, 
  29.1891).. controls (-0.6501, 29.1949) and (-0.5144, 29.4372) .. (-0.5144, 
  29.4372).. controls (-0.5088, 29.7013) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.7561, 154.9735)}]
      \path[fill=cc98e37,even odd rule] (0.0, 30.0) -- (0.0878, 30.3146).. 
  controls (0.0878, 30.3146) and (-0.3455, 30.7885) .. (-0.7096, 31.7751).. 
  controls (-0.7096, 31.7751) and (-0.7924, 31.8254) .. (-0.8046, 32.0018).. 
  controls (-0.8046, 32.0018) and (-0.8054, 32.0299) .. (-0.8684, 32.0415).. 
  controls (-0.8684, 32.0415) and (-0.9081, 32.0466) .. (-0.9451, 32.0791) -- 
  (-0.9755, 32.0918).. controls (-0.9755, 32.0918) and (-1.0149, 32.0235) .. 
  (-1.0417, 32.0182).. controls (-1.0417, 32.0182) and (-0.8827, 31.9434) .. 
  (-0.8636, 31.8624).. controls (-0.8636, 31.8624) and (-0.9022, 31.8195) .. 
  (-1.0885, 31.9172).. controls (-1.0885, 31.9172) and (-1.1679, 31.9704) .. 
  (-1.1835, 32.0114).. controls (-1.1835, 32.0114) and (-0.9665, 31.6716) .. 
  (-0.7707, 31.5237).. controls (-0.7707, 31.5237) and (-0.4604, 30.6625) .. 
  (-0.1826, 30.3426) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.0225, 156.3613)}]
      \path[fill=cc98e37,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.8903, 30.0206) .. (1.0012, 29.9947).. controls (1.0835, 29.9757) and 
  (1.6936, 29.9045) .. (1.8367, 29.5494).. controls (1.8367, 29.5494) and 
  (1.7367, 29.9746) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.4101, 155.3062)}]
      \path[fill=cc98e37,nonzero rule] (0.0, 30.0) -- (-0.1662, 30.0823).. 
  controls (-0.2754, 30.1275) and (-0.3945, 30.1632) .. (-0.5138, 30.1606).. 
  controls (-0.5577, 30.1595) and (-0.6019, 30.1524) .. (-0.6432, 30.1368).. 
  controls (-0.699, 30.1154) and (-0.7377, 30.087) .. (-0.7678, 30.0347).. 
  controls (-0.7826, 30.0093) and (-0.7975, 29.9841) .. (-0.812, 29.9582).. 
  controls (-0.8591, 29.8767) and (-0.9059, 29.7955) .. (-0.953, 29.7137).. 
  controls (-1.0102, 29.6148) and (-1.0673, 29.5155) .. (-1.1245, 29.4163).. 
  controls (-1.1758, 29.3274) and (-1.2271, 29.2385) .. (-1.2785, 29.1494).. 
  controls (-1.3078, 29.0986) and (-1.3372, 29.0475) .. (-1.3666, 28.9964) -- 
  (-1.3732, 28.9851).. controls (-1.3732, 28.9851) and (-1.5198, 28.684) .. 
  (-1.6457, 28.6157).. controls (-1.7717, 28.5469) and (-1.8621, 28.3876) .. 
  (-1.8621, 28.3876).. controls (-1.8621, 28.3876) and (-1.6923, 28.5181) .. 
  (-1.6002, 28.5226).. controls (-1.6002, 28.5226) and (-1.6412, 28.3747) .. 
  (-1.7679, 28.1638).. controls (-1.7679, 28.1638) and (-1.5367, 28.3601) .. 
  (-1.4475, 28.5906).. controls (-1.4475, 28.5906) and (-0.743, 29.7468) .. 
  (-0.5726, 29.8032).. controls (-0.4019, 29.8592) and (-0.2439, 29.5674) .. 
  (-0.2439, 29.5674) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.5922, 155.9101)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (0.0355, 30.0122) -- 
  (0.054, 30.0191) -- (0.0743, 30.0312) -- (0.1217, 30.0648) -- (0.1701, 
  30.1124) -- (0.2164, 30.1717).. controls (0.2474, 30.2143) and (0.2725, 
  30.2638) .. (0.2961, 30.3135).. controls (0.3186, 30.3641) and (0.3376, 
  30.4154) .. (0.353, 30.4649).. controls (0.3678, 30.5138) and (0.3794, 
  30.5604) .. (0.3868, 30.6006).. controls (0.3953, 30.6408) and (0.3985, 
  30.6752) .. (0.4019, 30.699) -- (0.4048, 30.7361).. controls (0.4048, 30.7361)
   and (0.386, 30.6855) .. (0.3577, 30.6091).. controls (0.3434, 30.5712) and 
  (0.3265, 30.5273) .. (0.3088, 30.4797).. controls (0.29, 30.4334) and (0.2707,
   30.3834) .. (0.2479, 30.3355).. controls (0.2371, 30.3114) and (0.2262, 
  30.2865) .. (0.2138, 30.2638) -- (0.1773, 30.1969) -- (0.1392, 30.1368) -- 
  (0.1005, 30.0865) -- (0.0638, 30.0479) -- (0.0476, 30.032) -- (0.031, 30.0212)
   -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.2231, 155.3429)}]
      \path[fill=cc98e37,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.3789, 29.7037) .. (-1.9696, 30.2016).. controls (-1.9696, 30.2016) and 
  (-2.0675, 30.0527) .. (-1.9754, 29.7849) -- (-1.8555, 29.8463).. controls 
  (-1.8555, 29.8463) and (-1.8471, 30.0564) .. (-1.6465, 29.9958).. controls 
  (-1.4457, 29.9352) and (-0.6324, 29.4645) .. (-0.3844, 29.5698).. controls 
  (-0.1363, 29.6751) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.7145, 154.9054)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0119, 29.9857) .. (-0.0204, 29.9614) -- (-0.0304, 29.9182) -- (-0.0307, 
  29.8674) -- (-0.0172, 29.818) -- (0.0066, 29.7785) -- (0.0312, 29.7574) -- 
  (0.0421, 29.7518) -- (0.0397, 29.7637) -- (0.0336, 29.7926).. controls 
  (0.0296, 29.8156) and (0.0254, 29.8442) .. (0.022, 29.8741).. controls (0.018,
   29.904) and (0.0143, 29.9344) .. (0.0098, 29.9585).. controls (0.0056, 
  29.9825) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.0865, 156.4909)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.535, 29.877) .. (-0.3268, 30.3074).. controls (-0.3204, 30.3204) and 
  (-0.4686, 30.0093) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-50.7785, 156.5911)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.4419, 30.0532) .. (0.5755, 30.0).. controls (0.5755, 30.0) and (0.1167, 
  30.1249) .. (0.0, 30.1421).. controls (-0.1164, 30.159) and (-0.1987, 30.1085)
   .. (-0.1987, 30.1085) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.7778, 154.1758)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0) -- (0.1402, 29.9497).. 
  controls (0.1402, 29.9497) and (-0.163, 30.9168) .. (-0.236, 30.9932).. 
  controls (-0.236, 30.9932) and (-0.3813, 31.0755) .. (-0.4101, 31.0578).. 
  controls (-0.4101, 31.0578) and (-0.0714, 30.603) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.0585, 157.5373)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1291, 30.335) .. (0.2357, 30.4337).. controls (0.2357, 30.4337) and 
  (0.0587, 30.2699) .. (0.0, 30.1442) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-45.805, 156.7201)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0034, 30.0294) -- 
  (0.0206, 30.0185) -- cycle(-1.4422, 33.4441) -- (-1.3772, 33.4586) -- 
  (-1.3727, 33.4891).. controls (-1.36, 33.5049) and (-1.3205, 33.5102) .. 
  (-1.2668, 33.5015).. controls (-1.148, 33.4832) and (-1.1329, 33.3525) .. 
  (-1.1279, 33.2314) -- (-1.1258, 33.1919).. controls (-1.1173, 33.102) and 
  (-1.0054, 33.0078) .. (-0.9927, 32.9972) -- (-0.9628, 32.9729) -- (-0.943, 
  33.0057).. controls (-0.9234, 33.0372) and (-0.8916, 33.0652) .. (-0.848, 
  33.089) -- (-0.8438, 33.0911) -- (-0.8435, 33.0914).. controls (-0.8485, 
  33.0668) and (-0.8496, 33.0398) .. (-0.8467, 33.0094).. controls (-0.8295, 
  32.826) and (-0.939, 32.7649) .. (-0.9438, 32.7625) -- (-1.0065, 32.7286) -- 
  (-0.9406, 32.7019).. controls (-0.9374, 32.7006) and (-0.907, 32.689) .. 
  (-0.8665, 32.689).. controls (-0.8096, 32.689) and (-0.7607, 32.7117) .. 
  (-0.7247, 32.7554).. controls (-0.7022, 32.7829) and (-0.6808, 32.8046) .. 
  (-0.6625, 32.8213).. controls (-0.666, 32.7797) and (-0.6697, 32.7199) .. 
  (-0.6712, 32.6363).. controls (-0.675, 32.4617) and (-0.8435, 32.4172) .. 
  (-0.8504, 32.4154) -- (-0.9017, 32.4024) -- (-0.8684, 32.3617).. controls 
  (-0.866, 32.3588) and (-0.8104, 32.2926) .. (-0.7157, 32.2926).. controls 
  (-0.6731, 32.2926) and (-0.6294, 32.3061) .. (-0.5858, 32.3328) -- (-0.5249, 
  32.3654).. controls (-0.5461, 32.3347) and (-0.5614, 32.2984) .. (-0.5765, 
  32.2627).. controls (-0.6136, 32.1751) and (-0.6488, 32.0926) .. (-0.7599, 
  32.087).. controls (-0.9919, 32.0754) and (-1.0456, 32.0201) .. (-1.0565, 
  32.0032) -- (-1.07, 31.9831) -- (-1.0549, 31.964).. controls (-1.0329, 
  31.9365) and (-1.0086, 31.8465) .. (-1.0224, 31.7949) -- (-1.0411, 31.7685) --
   (-1.07, 31.764) -- (-1.1023, 31.7597).. controls (-1.1808, 31.7418) and 
  (-1.2615, 31.7066) .. (-1.3563, 31.6491).. controls (-1.5954, 31.5052) and 
  (-1.5978, 31.3123) .. (-1.6013, 31.0208).. controls (-1.605, 30.7239) and 
  (-1.6759, 30.5427) .. (-1.6764, 30.5408) -- (-1.742, 30.3762) -- (-1.6211, 
  30.5056).. controls (-1.5192, 30.6146) and (-1.3965, 30.6329) .. (-1.3152, 
  30.6305) -- (-1.3486, 30.5895).. controls (-1.3901, 30.5194) and (-1.3695, 
  30.4405) .. (-1.3687, 30.4374) -- (-1.3483, 30.3627) -- (-1.3078, 30.4286).. 
  controls (-1.2607, 30.5056) and (-1.1639, 30.5448) .. (-1.0205, 30.5448).. 
  controls (-0.9387, 30.5448) and (-0.8573, 30.5315) .. (-0.798, 30.5186).. 
  controls (-0.9462, 30.4424) and (-1.0163, 30.3569) .. (-1.0197, 30.3527) -- 
  (-1.0602, 30.3024) -- (-0.9956, 30.2982).. controls (-0.5813, 30.2715) and 
  (-0.3577, 30.1812) .. (-0.3553, 30.1802) -- (-0.3053, 30.1593) -- (-0.3077, 
  30.1921) -- (-0.2865, 30.2024).. controls (-0.2535, 30.2143) and (-0.2164, 
  30.2246) .. (-0.1807, 30.2344).. controls (-0.1558, 30.241) and (-0.1344, 
  30.2463) .. (-0.113, 30.2511).. controls (-0.0357, 30.2696) and (0.0439, 
  30.2884) .. (0.1109, 30.3384) -- (0.1498, 30.3739) -- (0.149, 30.3688) -- 
  (0.1466, 30.345).. controls (0.1426, 30.3032) and (0.1365, 30.2675) .. 
  (0.1281, 30.2355).. controls (0.1135, 30.1812) and (0.0929, 30.1355) .. 
  (0.0669, 30.099).. controls (0.0489, 30.0736) and (0.0291, 30.054) .. (0.0079,
   30.04) -- (-0.0124, 30.0275) -- (-0.0008, 29.9992) -- (-0.0291, 29.9738).. 
  controls (0.0339, 29.9037) and (0.0804, 29.8148) .. (0.1257, 29.7288).. 
  controls (0.2122, 29.5632) and (0.1744, 29.3928) .. (0.1275, 29.2787).. 
  controls (0.1082, 29.2314) and (0.077, 29.1809) .. (0.0302, 29.1211).. 
  controls (-0.1471, 28.894) and (-0.4096, 28.7837) .. (-0.7723, 28.7837).. 
  controls (-1.0845, 28.7837) and (-1.4179, 28.866) .. (-1.6859, 28.9319).. 
  controls (-1.7941, 28.9583) and (-1.9021, 28.9869) .. (-2.01, 29.0152).. 
  controls (-2.3011, 29.092) and (-2.6022, 29.1713) .. (-2.9062, 29.2126).. 
  controls (-3.0141, 29.2272) and (-3.1086, 29.2346) .. (-3.1954, 29.2346).. 
  controls (-3.3843, 29.2346) and (-3.5407, 29.2007) .. (-3.6743, 29.1322).. 
  controls (-3.7656, 29.0851) and (-3.8349, 29.0261) .. (-3.8809, 28.9565).. 
  controls (-3.9481, 28.8541) and (-3.9635, 28.757) .. (-3.9259, 28.6676).. 
  controls (-3.8317, 28.444) and (-3.4356, 28.345) .. (-3.2695, 28.313).. 
  controls (-3.1427, 28.2884) and (-3.0149, 28.276) .. (-2.8895, 28.276).. 
  controls (-2.6829, 28.276) and (-2.4866, 28.3093) .. (-2.3061, 28.3752).. 
  controls (-2.2439, 28.3979) and (-2.1823, 28.4252) .. (-2.1222, 28.4514).. 
  controls (-1.9672, 28.5189) and (-1.8206, 28.5829) .. (-1.6624, 28.5829) -- 
  (-1.6523, 28.5829).. controls (-1.5211, 28.5808) and (-1.3922, 28.5313) .. 
  (-1.2679, 28.4837).. controls (-1.2332, 28.4704) and (-1.1983, 28.4572) .. 
  (-1.1634, 28.4448) -- (-1.1107, 28.4252).. controls (-1.0562, 28.4043) and 
  (-1.0168, 28.389) .. (-0.9414, 28.3821).. controls (-0.8737, 28.3755) and 
  (-0.8049, 28.3765) .. (-0.7427, 28.3845).. controls (-0.8117, 28.3027) and 
  (-0.9324, 28.2646) .. (-1.0033, 28.249).. controls (-1.0229, 28.2442) and 
  (-1.0504, 28.2426) .. (-1.0769, 28.2411) -- (-1.1443, 28.235) -- (-1.2822, 
  28.2114) -- (-1.1486, 28.1704).. controls (-1.0925, 28.1529) and (-1.0784, 
  28.1466) .. (-1.0546, 28.1336).. controls (-1.0268, 28.1191) and (-0.9993, 
  28.1016) .. (-0.9747, 28.0836).. controls (-0.9454, 28.0617) and (-0.9197, 
  28.036) .. (-0.8927, 28.0087).. controls (-0.87, 27.986) and (-0.8467, 
  27.9627) .. (-0.8207, 27.9413).. controls (-0.7514, 27.8847) and (-0.6776, 
  27.8468) .. (-0.6009, 27.8283) -- (-0.5395, 27.8206) -- (-0.5099, 27.818).. 
  controls (-0.3154, 27.7939) and (-0.208, 27.7389) .. (-0.15, 27.6926).. 
  controls (-0.1947, 27.7021) and (-0.2511, 27.7095) .. (-0.3154, 27.7095).. 
  controls (-0.4125, 27.7095) and (-0.5069, 27.6918) .. (-0.5953, 27.6569).. 
  controls (-0.6458, 27.637) and (-0.6972, 27.6238) .. (-0.748, 27.6166).. 
  controls (-0.8149, 27.6076) and (-0.8832, 27.61) .. (-0.9475, 27.6238).. 
  controls (-1.0189, 27.6394) and (-1.0753, 27.6621) .. (-1.138, 27.6915).. 
  controls (-1.1718, 27.7074) and (-1.215, 27.7317) .. (-1.2504, 27.7545) -- 
  (-1.2946, 27.7873).. controls (-1.3113, 27.8005) and (-1.3285, 27.8145) .. 
  (-1.3581, 27.8309) -- (-1.3819, 27.8447).. controls (-1.4113, 27.863) and 
  (-1.4446, 27.8831) .. (-1.4835, 27.8862) -- (-1.6592, 27.9011) -- (-1.5012, 
  27.8233).. controls (-1.4544, 27.8) and (-1.4404, 27.7574) .. (-1.4211, 
  27.6987) -- (-1.4176, 27.6883).. controls (-1.406, 27.6531) and (-1.3962, 
  27.6158) .. (-1.3885, 27.5769).. controls (-1.5515, 27.7746) and (-1.7873, 
  27.7931) .. (-1.7992, 27.7939) -- (-1.8164, 27.7936).. controls (-1.8833, 
  27.7936) and (-2.1161, 27.8085) .. (-2.2984, 27.9979).. controls (-2.3556, 
  28.0572) and (-2.4172, 28.1051) .. (-2.4815, 28.1395).. controls (-2.5532, 
  28.1776) and (-2.6181, 28.1863) .. (-2.6892, 28.1932).. controls (-2.7607, 
  28.1998) and (-2.8453, 28.2032) .. (-2.935, 28.2069).. controls (-3.3888, 
  28.2252) and (-4.0103, 28.2506) .. (-4.078, 28.7308).. controls (-4.1124, 
  28.9766) and (-4.0026, 29.1544) .. (-3.7219, 29.3071).. controls (-3.561, 
  29.3946) and (-3.357, 29.4076) .. (-3.2176, 29.4097) -- (-3.211, 29.4097).. 
  controls (-3.1467, 29.4097) and (-3.0856, 29.3957) .. (-3.021, 29.3811).. 
  controls (-2.9565, 29.3669) and (-2.8895, 29.3518) .. (-2.8191, 29.3518) -- 
  (-2.8088, 29.3518).. controls (-2.79, 29.352) and (-2.7339, 29.3534) .. 
  (-2.7067, 29.3965).. controls (-2.6771, 29.4438) and (-2.7014, 29.5044) .. 
  (-2.7686, 29.5513).. controls (-2.817, 29.5849) and (-2.8673, 29.6158) .. 
  (-2.9194, 29.6431).. controls (-2.8154, 29.651) and (-2.7075, 29.6264) .. 
  (-2.6149, 29.5732).. controls (-2.5744, 29.5499) and (-2.5366, 29.5193) .. 
  (-2.4966, 29.4862).. controls (-2.4466, 29.4452) and (-2.395, 29.4028) .. 
  (-2.3365, 29.3761) -- (-2.2924, 29.3557) -- (-2.2889, 29.4039).. controls 
  (-2.2841, 29.4798) and (-2.3212, 29.5711) .. (-2.3373, 29.6071).. controls 
  (-2.3506, 29.6362) and (-2.3802, 29.6672) .. (-2.4133, 29.6947).. controls 
  (-2.3752, 29.6867) and (-2.341, 29.6754) .. (-2.3188, 29.6679) -- (-2.3048, 
  29.6632).. controls (-2.2442, 29.6436) and (-2.1847, 29.619) .. (-2.128, 
  29.5894).. controls (-2.0714, 29.5597) and (-2.0169, 29.5251) .. (-1.9664, 
  29.4867) -- (-1.9301, 29.4603).. controls (-1.8947, 29.4349) and (-1.8579, 
  29.4092) .. (-1.837, 29.3766) -- (-1.801, 29.3208) -- (-1.7775, 29.3827).. 
  controls (-1.7333, 29.5002) and (-1.6695, 29.5703) .. (-1.5703, 29.6097).. 
  controls (-1.4952, 29.6396) and (-1.4139, 29.6505) .. (-1.3319, 29.6555).. 
  controls (-1.3896, 29.6037) and (-1.4454, 29.5394) .. (-1.4676, 29.4587).. 
  controls (-1.4962, 29.3557) and (-1.4647, 29.2348) .. (-1.3854, 29.1435).. 
  controls (-1.3221, 29.07) and (-1.23, 29.0139) .. (-1.1118, 28.9758).. 
  controls (-0.8816, 28.9017) and (-0.6157, 28.9189) .. (-0.3969, 29.0221).. 
  controls (-0.2175, 29.1068) and (-0.0929, 29.2417) .. (-0.055, 29.392).. 
  controls (-0.018, 29.5394) and (-0.0638, 29.71) .. (-0.1744, 29.8378).. 
  controls (-0.2686, 29.9466) and (-0.4067, 30.0262) .. (-0.5734, 30.068).. 
  controls (-0.6829, 30.0953) and (-0.8025, 30.1074) .. (-0.9618, 30.1074) -- 
  (-1.0266, 30.1066).. controls (-1.1036, 30.1056) and (-1.1843, 30.1027) .. 
  (-1.2666, 30.0976).. controls (-1.4891, 30.0844) and (-1.7259, 30.0582) .. 
  (-2.0111, 30.0156).. controls (-2.1198, 29.9992) and (-2.2373, 29.9802) .. 
  (-2.3807, 29.9558).. controls (-2.4051, 29.9516) and (-2.4299, 29.9471) .. 
  (-2.4548, 29.9423).. controls (-2.5413, 29.9264) and (-2.6308, 29.91) .. 
  (-2.7173, 29.91) -- (-2.7824, 29.9135).. controls (-2.8646, 29.9225) and 
  (-2.9525, 29.9471) .. (-3.0599, 29.9905).. controls (-3.1573, 30.0299) and 
  (-3.2856, 30.0503) .. (-3.4414, 30.0503).. controls (-3.6449, 30.0503) and 
  (-3.8214, 30.0161) .. (-3.8288, 30.0148) -- (-3.8386, 30.0111).. controls 
  (-3.8555, 30.0019) and (-3.8783, 29.9971) .. (-3.906, 29.9971).. controls 
  (-3.96, 29.9971) and (-4.0116, 30.0148) .. (-4.0121, 30.0148) -- (-4.0217, 
  30.0169) -- (-4.5805, 30.0402).. controls (-4.6445, 30.0474) and (-6.2074, 
  30.2188) .. (-6.4733, 30.2188).. controls (-6.5029, 30.2188) and (-6.5135, 
  30.217) .. (-6.5215, 30.2138).. controls (-6.6127, 30.1749) and (-6.9167, 
  30.0138) .. (-7.1078, 29.7883).. controls (-7.2816, 29.5838) and (-7.3197, 
  29.4425) .. (-7.3425, 29.3581) -- (-7.3522, 29.3243).. controls (-7.3721, 
  29.2621) and (-7.3607, 29.1671) .. (-7.3512, 29.083).. controls (-7.348, 
  29.057) and (-7.3451, 29.0332) .. (-7.3435, 29.0118).. controls (-7.3401, 
  28.9657) and (-7.3583, 28.9398) .. (-7.3684, 28.9306).. controls (-7.398, 
  28.9454) and (-7.4446, 28.9565) .. (-7.4451, 28.9565) -- (-7.4562, 28.9578) --
   (-7.5001, 28.9403) -- (-7.5123, 28.9327).. controls (-7.5203, 28.952) and 
  (-7.5261, 29.0105) .. (-7.5248, 29.0655) -- (-7.5226, 29.1615) -- (-7.584, 
  29.0877).. controls (-7.5962, 29.0732) and (-7.5983, 29.0523) .. (-7.6044, 
  28.9962).. controls (-7.6068, 28.9755) and (-7.6094, 28.9507) .. (-7.6131, 
  28.9213).. controls (-7.6189, 28.8758) and (-7.6398, 28.8779) .. (-7.6483, 
  28.8779).. controls (-7.6682, 28.8983) and (-7.6859, 28.9038) .. (-7.7126, 
  28.902).. controls (-7.7211, 28.9015) and (-7.7301, 28.8983) .. (-7.7586, 
  28.9097) -- (-7.7653, 28.9163).. controls (-7.769, 28.9261) and (-7.7729, 
  28.9589) .. (-7.7282, 29.0488).. controls (-7.716, 29.0732) and (-7.693, 
  29.1824) .. (-7.7115, 29.2126) -- (-7.7213, 29.2285) -- (-7.7547, 29.2298) -- 
  (-7.7666, 29.2203).. controls (-7.7766, 29.2113) and (-7.7872, 29.1936) .. 
  (-7.8153, 29.1451).. controls (-7.8367, 29.1076) and (-7.8634, 29.0607) .. 
  (-7.8848, 29.0329) -- (-7.9113, 29.0197) -- (-7.9505, 29.0308).. controls 
  (-7.9595, 29.043) and (-7.9788, 29.0644) .. (-8.015, 29.084) -- (-8.0245, 
  29.1047).. controls (-8.0261, 29.1274) and (-8.0134, 29.1647) .. (-7.9719, 
  29.1949).. controls (-7.9073, 29.242) and (-7.8396, 29.3362) .. (-7.8523, 
  29.3822) -- (-7.887, 29.4116) -- (-7.8915, 29.4118).. controls (-7.9174, 
  29.4118) and (-7.9772, 29.3827) .. (-8.0288, 29.3549).. controls (-8.0521, 
  29.3721) and (-8.0941, 29.4116) .. (-8.0896, 29.4708).. controls (-8.0841, 
  29.5433) and (-7.9666, 29.5531) .. (-7.9655, 29.5531) -- (-7.951, 29.5542) -- 
  (-7.9417, 29.5656).. controls (-7.8684, 29.6574) and (-7.8311, 29.674) .. 
  (-7.784, 29.6949) -- (-7.742, 29.7145).. controls (-7.7219, 29.7251) and 
  (-7.6658, 29.7537) .. (-7.6581, 29.7905).. controls (-7.6433, 29.8188) and 
  (-7.5861, 29.9323) .. (-7.5798, 30.0212).. controls (-7.5713, 30.1373) and 
  (-7.6769, 30.2344) .. (-7.8253, 30.2471).. controls (-7.8682, 30.2506) and 
  (-7.8986, 30.2585) .. (-7.9195, 30.2675).. controls (-7.8745, 30.2844) and 
  (-7.8089, 30.3119) .. (-7.7375, 30.3487).. controls (-7.6166, 30.4114) and 
  (-7.4467, 30.4292) .. (-7.4451, 30.4294) -- (-7.3848, 30.4355) -- (-7.4218, 
  30.4829).. controls (-7.4276, 30.4903) and (-7.5636, 30.6628) .. (-7.7277, 
  30.6937) -- (-7.7875, 30.7104).. controls (-7.733, 30.7289) and (-7.6552, 
  30.7623) .. (-7.5631, 30.8207).. controls (-7.5038, 30.8586) and (-7.4398, 
  30.8776) .. (-7.3721, 30.8776).. controls (-7.3017, 30.8776) and (-7.2525, 
  30.8565) .. (-7.252, 30.8559) -- (-7.1747, 30.821) -- (-7.2075, 30.8993).. 
  controls (-7.2096, 30.9046) and (-7.2615, 31.0266) .. (-7.3546, 31.0803) -- 
  (-7.4157, 31.1152) -- (-7.3432, 31.12).. controls (-7.2811, 31.13) and 
  (-7.2252, 31.1345) .. (-7.1747, 31.1345).. controls (-7.0723, 31.1345) and 
  (-7.0125, 31.1155) .. (-6.9771, 31.1041) -- (-6.9342, 31.0946).. controls 
  (-6.8937, 31.0946) and (-6.8604, 31.1335) .. (-6.8337, 31.1652) -- (-6.8149, 
  31.1861).. controls (-6.7598, 31.2364) and (-6.7109, 31.2726) .. (-6.6498, 
  31.2851).. controls (-6.5447, 31.3057) and (-6.4222, 31.2864) .. (-6.2836, 
  31.2269).. controls (-6.2542, 31.2142) and (-5.9587, 31.0581) .. (-5.9402, 
  31.0467) -- (-5.9227, 31.0747) -- (-5.9216, 31.0742) -- (-5.8931, 31.057).. 
  controls (-5.8782, 31.0814) and (-5.7512, 31.2954) .. (-5.7208, 31.3996).. 
  controls (-5.6833, 31.5282) and (-5.7772, 32.2543) .. (-5.778, 32.2617).. 
  controls (-5.7976, 32.4104) and (-5.9066, 32.7234) .. (-5.9111, 32.7366).. 
  controls (-5.9145, 32.7453) and (-5.9846, 32.9329) .. (-6.0568, 33.003).. 
  controls (-6.1169, 33.0615) and (-6.2177, 33.1057) .. (-6.3066, 33.1451) -- 
  (-6.3585, 33.1681).. controls (-6.4476, 33.2089) and (-6.4638, 33.2406) .. 
  (-6.4667, 33.2962).. controls (-6.4672, 33.3102) and (-6.4556, 33.3179) .. 
  (-6.4095, 33.3335).. controls (-6.3754, 33.3446) and (-6.3365, 33.3576) .. 
  (-6.3233, 33.3933) -- (-6.309, 33.398).. controls (-6.2902, 33.3991) and 
  (-6.2548, 33.401) .. (-6.2373, 33.442) -- (-6.1942, 33.4692).. controls 
  (-6.1693, 33.4652) and (-6.1203, 33.4708) .. (-6.0481, 33.4864) -- (-5.9976, 
  33.4922) -- (-5.9642, 33.4854) -- (-5.9611, 33.4446) -- (-5.9193, 33.4605).. 
  controls (-5.9187, 33.461) and (-5.8576, 33.4838) .. (-5.7891, 33.4854) -- 
  (-5.7729, 33.4859).. controls (-5.7264, 33.4859) and (-5.7195, 33.4806) .. 
  (-5.6859, 33.4573) -- (-5.6793, 33.4528) -- (-5.6208, 33.4311).. controls 
  (-5.588, 33.424) and (-5.5729, 33.4208) .. (-5.5658, 33.3708).. controls 
  (-5.5494, 33.2589) and (-5.5179, 33.216) .. (-5.5142, 33.212) -- (-5.5107, 
  33.2078).. controls (-5.4443, 33.1472) and (-5.3885, 33.1179) .. (-5.3404, 
  33.1179).. controls (-5.3112, 33.1179) and (-5.2851, 33.1287) .. (-5.2644, 
  33.1496) -- (-5.2298, 33.2062).. controls (-5.2086, 33.0946) and (-5.2393, 
  32.98) .. (-5.2398, 32.9784) -- (-5.2417, 32.9718) -- (-5.2406, 32.9647).. 
  controls (-5.2353, 32.9279) and (-5.2065, 32.9033) .. (-5.1686, 32.9033).. 
  controls (-5.1274, 32.9033) and (-5.0739, 32.9334) .. (-5.0469, 33.0017).. 
  controls (-5.0358, 33.0292) and (-5.0202, 33.0551) .. (-5.0046, 33.0771).. 
  controls (-5.0041, 33.0366) and (-5.0019, 32.9826) .. (-4.9969, 32.9128).. 
  controls (-4.9842, 32.7366) and (-5.0334, 32.6374) .. (-5.034, 32.6363) -- 
  (-5.0594, 32.5863) -- (-5.0035, 32.5876).. controls (-4.9993, 32.5876) and 
  (-4.8982, 32.5919) .. (-4.8654, 32.7252).. controls (-4.8572, 32.7591) and 
  (-4.8445, 32.785) .. (-4.8313, 32.8048) -- (-4.8313, 32.7652).. controls 
  (-4.8318, 32.7257) and (-4.8249, 32.6892) .. (-4.8183, 32.6538) -- (-4.8085, 
  32.5945).. controls (-4.8038, 32.5527) and (-4.8054, 32.5101) .. (-4.8136, 
  32.468).. controls (-4.8189, 32.44) and (-4.8281, 32.4098) .. (-4.8416, 
  32.3741) -- (-4.8466, 32.3622) -- (-4.8617, 32.3114) -- (-4.8482, 32.2704) -- 
  (-4.8128, 32.2558).. controls (-4.8001, 32.2558) and (-4.7612, 32.2558) .. 
  (-4.672, 32.3548).. controls (-4.649, 32.3805) and (-4.627, 32.3966) .. 
  (-4.608, 32.4064).. controls (-4.6456, 32.3432) and (-4.667, 32.2651) .. 
  (-4.676, 32.1635).. controls (-4.6863, 32.0436) and (-4.8083, 31.9206) .. 
  (-4.8093, 31.919) -- (-4.831, 31.8973) -- (-4.8112, 31.874).. controls 
  (-4.7146, 31.7603) and (-4.6921, 31.7169) .. (-4.6871, 31.7037) -- (-4.7501, 
  31.4272) -- (-4.676, 31.4854).. controls (-4.6546, 31.502) and (-4.6035, 
  31.5282) .. (-4.4815, 31.5576).. controls (-4.4154, 31.5732) and (-4.3736, 
  31.6158) .. (-4.3471, 31.6587).. controls (-4.3389, 31.547) and (-4.3691, 
  31.4518) .. (-4.3696, 31.4504) -- (-4.4302, 31.2637) -- (-4.3111, 31.42).. 
  controls (-4.309, 31.4229) and (-4.2497, 31.4962) .. (-4.1037, 31.515).. 
  controls (-4.0304, 31.5243) and (-3.9688, 31.537) .. (-3.9222, 31.5481) -- 
  (-4.136, 31.2576) -- (-4.0193, 31.3105).. controls (-4.018, 31.3113) and 
  (-3.8994, 31.3642) .. (-3.792, 31.3721).. controls (-3.7587, 31.3742) and 
  (-3.7314, 31.3737) .. (-3.71, 31.3719).. controls (-3.7949, 31.2994) and 
  (-3.8111, 31.1925) .. (-3.8119, 31.1872) -- (-3.8177, 31.1454) -- (-3.3496, 
  31.1845) -- (-3.4891, 31.0591) -- (-3.4364, 31.0406).. controls (-3.3642, 
  31.0147) and (-3.2832, 31.0014) .. (-3.1959, 31.0014).. controls (-2.9424, 
  31.0014) and (-2.7096, 31.1105) .. (-2.6831, 31.1271).. controls (-2.6437, 
  31.1515) and (-2.6255, 31.22) .. (-2.5702, 31.4788).. controls (-2.5289, 
  31.6724) and (-2.3932, 31.8095) .. (-2.1881, 31.8643).. controls (-1.9645, 
  31.9243) and (-1.8087, 32.0164) .. (-1.7367, 32.1304).. controls (-1.6576, 
  32.2558) and (-1.5785, 32.5871) .. (-1.5909, 32.8429).. controls (-1.5991, 
  33.0136) and (-1.6915, 33.1438) .. (-1.8505, 33.211) -- (-1.855, 33.2128) -- 
  (-1.8828, 33.2216).. controls (-1.9622, 33.2441) and (-2.0098, 33.2695) .. 
  (-2.0032, 33.3274).. controls (-2.0003, 33.3528) and (-1.9913, 33.3758) .. 
  (-1.9444, 33.3758).. controls (-1.9174, 33.3758) and (-1.8928, 33.3676) .. 
  (-1.8926, 33.3674) -- (-1.8526, 33.3541) -- (-1.8484, 33.3959).. controls 
  (-1.8457, 33.4227) and (-1.7534, 33.4443) .. (-1.6756, 33.4449) -- (-1.6653, 
  33.4467).. controls (-1.6081, 33.4663) and (-1.5597, 33.4761) .. (-1.5211, 
  33.4761).. controls (-1.4528, 33.4761) and (-1.4428, 33.4454) .. (-1.4422, 
  33.4441)(-1.3142, 33.5724).. controls (-1.3655, 33.5727) and (-1.4028, 
  33.5581) .. (-1.425, 33.5303) -- (-1.4303, 33.5229).. controls (-1.4512, 
  33.5346) and (-1.4806, 33.543) .. (-1.5211, 33.543).. controls (-1.5658, 
  33.543) and (-1.6198, 33.5325) .. (-1.6817, 33.5118).. controls (-1.723, 
  33.5108) and (-1.8584, 33.5028) .. (-1.9018, 33.4385) -- (-1.9444, 33.443).. 
  controls (-2.0164, 33.443) and (-2.0619, 33.4033) .. (-2.0696, 33.3348).. 
  controls (-2.0839, 33.2089) and (-1.9555, 33.1726) .. (-1.9008, 33.1573) -- 
  (-1.8817, 33.1515) -- (-1.8764, 33.1491).. controls (-1.7044, 33.0771) and 
  (-1.6626, 32.9411) .. (-1.6576, 32.8398).. controls (-1.6449, 32.58) and 
  (-1.7296, 32.2672) .. (-1.7931, 32.1659).. controls (-1.8561, 32.0664) and 
  (-1.9984, 31.9844) .. (-2.2053, 31.9288).. controls (-2.436, 31.8672) and 
  (-2.5887, 31.7124) .. (-2.6355, 31.4928).. controls (-2.6646, 31.3557) and 
  (-2.6977, 31.2009) .. (-2.7189, 31.1835).. controls (-2.7416, 31.1692) and 
  (-2.9615, 31.0684) .. (-3.1959, 31.0684).. controls (-3.2536, 31.0684) and 
  (-3.3081, 31.0745) .. (-3.3584, 31.0866) -- (-3.1589, 31.2663) -- (-3.5052, 
  31.2398) -- (-3.7341, 31.2197).. controls (-3.7185, 31.2618) and (-3.6841, 
  31.3245) .. (-3.6129, 31.3536) -- (-3.5541, 31.3774) -- (-3.6071, 31.4126).. 
  controls (-3.6121, 31.4158) and (-3.664, 31.4483) .. (-3.7968, 31.4385).. 
  controls (-3.8468, 31.4351) and (-3.8976, 31.4232) .. (-3.9404, 31.4105) -- 
  (-3.7476, 31.6724) -- (-3.8489, 31.6372).. controls (-3.85, 31.637) and 
  (-3.9542, 31.6015) .. (-4.1122, 31.5814).. controls (-4.1881, 31.5716) and 
  (-4.2452, 31.5483) .. (-4.2855, 31.5251).. controls (-4.2757, 31.5949) and 
  (-4.2722, 31.6941) .. (-4.3061, 31.791) -- (-4.3527, 31.923) -- (-4.3709, 
  31.7841).. controls (-4.3709, 31.783) and (-4.3908, 31.6481) .. (-4.4971, 
  31.6224).. controls (-4.5588, 31.6076) and (-4.6088, 31.5925) .. (-4.6477, 
  31.5764) -- (-4.6207, 31.6859).. controls (-4.6138, 31.7087) and (-4.617, 
  31.7455) .. (-4.7413, 31.8947).. controls (-4.7016, 31.9397) and (-4.6191, 
  32.0466) .. (-4.6093, 32.1577).. controls (-4.5985, 32.2839) and (-4.5664, 
  32.3675) .. (-4.5064, 32.4297) -- (-4.4667, 32.4704) -- (-4.5217, 32.4852) -- 
  (-4.5506, 32.4881).. controls (-4.5847, 32.4881) and (-4.6524, 32.4765) .. 
  (-4.7215, 32.3995).. controls (-4.7477, 32.3707) and (-4.7683, 32.3521) .. 
  (-4.7834, 32.3402) -- (-4.7794, 32.3503).. controls (-4.7644, 32.3897) and 
  (-4.754, 32.4231) .. (-4.7479, 32.4553).. controls (-4.7387, 32.504) and 
  (-4.7366, 32.5535) .. (-4.7421, 32.6022) -- (-4.7527, 32.6662).. controls 
  (-4.7591, 32.6998) and (-4.7649, 32.7313) .. (-4.7646, 32.7644).. controls 
  (-4.7644, 32.7908) and (-4.7646, 32.8173) .. (-4.7651, 32.8435) -- (-4.7665, 
  32.9411) -- (-4.8157, 32.9133).. controls (-4.8191, 32.9115) and (-4.9003, 
  32.8641) .. (-4.9302, 32.7411) -- (-4.9427, 32.7064).. controls (-4.9318, 
  32.7583) and (-4.9239, 32.8292) .. (-4.9305, 32.9173).. controls (-4.9429, 
  33.0919) and (-4.9358, 33.1652) .. (-4.9358, 33.166) -- (-4.9268, 33.2538) -- 
  (-4.9916, 33.1938).. controls (-4.9948, 33.1909) and (-5.0718, 33.1194) .. 
  (-5.1088, 33.0263).. controls (-5.1252, 32.9853) and (-5.1541, 32.9699) .. 
  (-5.1686, 32.9699) -- (-5.1726, 32.9705).. controls (-5.1615, 33.017) and 
  (-5.1234, 33.2102) .. (-5.2144, 33.3475) -- (-5.2769, 33.442) -- (-5.2758, 
  33.3287).. controls (-5.2755, 33.3041) and (-5.2816, 33.2269) .. (-5.3118, 
  33.1964) -- (-5.3404, 33.1845).. controls (-5.361, 33.1845) and (-5.3988, 
  33.197) .. (-5.4629, 33.2546).. controls (-5.4674, 33.262) and (-5.4875, 
  33.2986) .. (-5.4996, 33.3803).. controls (-5.5134, 33.4766) and (-5.5697, 
  33.4885) .. (-5.6068, 33.4962) -- (-5.6412, 33.5076) -- (-5.6475, 33.5118).. 
  controls (-5.6909, 33.5425) and (-5.71, 33.5539) .. (-5.7907, 33.5523).. 
  controls (-5.842, 33.551) and (-5.8883, 33.5401) .. (-5.9161, 33.5319).. 
  controls (-5.9301, 33.5459) and (-5.9544, 33.5592) .. (-5.9976, 33.5592).. 
  controls (-6.0161, 33.5592) and (-6.0378, 33.5565) .. (-6.0619, 33.5515).. 
  controls (-6.142, 33.5348) and (-6.1714, 33.5346) .. (-6.1807, 33.5348) -- 
  (-6.1849, 33.5375) -- (-6.1947, 33.5367).. controls (-6.223, 33.5348) and 
  (-6.2767, 33.5182) .. (-6.2984, 33.4682) -- (-6.3127, 33.4647).. controls 
  (-6.3312, 33.4637) and (-6.3698, 33.4615) .. (-6.3862, 33.416) -- (-6.4307, 
  33.3965).. controls (-6.4728, 33.3824) and (-6.5368, 33.3613) .. (-6.5334, 
  33.2925).. controls (-6.5289, 33.2036) and (-6.4902, 33.1552) .. (-6.3862, 
  33.1073) -- (-6.3336, 33.0837).. controls (-6.2497, 33.0469) and (-6.1547, 
  33.0051) .. (-6.1034, 32.9551).. controls (-6.0523, 32.9057) and (-5.9925, 
  32.7641) .. (-5.974, 32.7141).. controls (-5.9732, 32.7112) and (-5.8629, 
  32.395) .. (-5.8441, 32.2532).. controls (-5.8113, 32.0034) and (-5.7605, 
  31.5026) .. (-5.7849, 31.4184).. controls (-5.8081, 31.3396) and (-5.8976, 
  31.1822) .. (-5.9343, 31.1184).. controls (-6.0317, 31.1782) and (-6.2545, 
  31.2869) .. (-6.2571, 31.288).. controls (-6.4101, 31.3536) and (-6.5434, 
  31.374) .. (-6.6627, 31.3504).. controls (-6.7437, 31.3343) and (-6.8053, 
  31.2853) .. (-6.8599, 31.2353) -- (-6.8845, 31.2084) -- (-6.9347, 31.1613) -- 
  (-6.957, 31.1679).. controls (-6.9935, 31.1795) and (-7.062, 31.2012) .. 
  (-7.1747, 31.2012).. controls (-7.2287, 31.2012) and (-7.2879, 31.1962) .. 
  (-7.3509, 31.1864) -- (-7.6449, 31.166) -- (-7.5459, 31.1113).. controls 
  (-7.5459, 31.1113) and (-7.4718, 31.0705) .. (-7.3877, 31.0221).. controls 
  (-7.3549, 31.0033) and (-7.3266, 30.9702) .. (-7.3057, 30.9393).. controls 
  (-7.3253, 30.9422) and (-7.3477, 30.9443) .. (-7.3721, 30.9443).. controls 
  (-7.4528, 30.9443) and (-7.529, 30.9218) .. (-7.5988, 30.8774).. controls 
  (-7.7658, 30.771) and (-7.8817, 30.7538) .. (-7.8827, 30.7538) -- (-7.955, 
  30.7435) -- (-7.9002, 30.6953).. controls (-7.8978, 30.6935) and (-7.8452, 
  30.6482) .. (-7.7401, 30.6281).. controls (-7.6483, 30.6109) and (-7.5626, 
  30.536) .. (-7.5147, 30.4868).. controls (-7.5795, 30.4757) and (-7.683, 
  30.4522) .. (-7.7679, 30.4083).. controls (-7.892, 30.344) and (-7.9997, 
  30.3101) .. (-8.0007, 30.3098) -- (-8.0402, 30.2974) -- (-8.0198, 30.2611).. 
  controls (-8.0158, 30.2545) and (-7.9772, 30.1929) .. (-7.8311, 30.1804).. 
  controls (-7.7219, 30.1707) and (-7.6406, 30.1032) .. (-7.6462, 30.0262).. 
  controls (-7.6525, 29.9405) and (-7.7195, 29.8174) .. (-7.72, 29.8164) -- 
  (-7.7264, 29.805) -- (-7.7261, 29.8042).. controls (-7.7317, 29.7987) and 
  (-7.7446, 29.7883) .. (-7.7727, 29.7738) -- (-7.8113, 29.7558).. controls 
  (-7.8605, 29.7341) and (-7.9071, 29.7135) .. (-7.9854, 29.6179).. controls 
  (-8.0283, 29.6116) and (-8.1478, 29.5849) .. (-8.1563, 29.4759).. controls 
  (-8.1658, 29.3528) and (-8.051, 29.2896) .. (-8.0462, 29.2869) -- (-8.0301, 
  29.2782) -- (-8.0142, 29.2872).. controls (-7.9899, 29.3004) and (-7.9624, 
  29.3145) .. (-7.9391, 29.3256).. controls (-7.9552, 29.301) and (-7.9798, 
  29.2719) .. (-8.0111, 29.2488).. controls (-8.0642, 29.2102) and (-8.0949, 
  29.1531) .. (-8.0912, 29.1002).. controls (-8.0888, 29.0666) and (-8.0727, 
  29.039) .. (-8.0468, 29.025).. controls (-8.014, 29.0075) and (-8.0031, 
  28.9896) .. (-8.0031, 28.9896) -- (-7.9989, 28.9827) -- (-7.9923, 28.9782).. 
  controls (-7.9883, 28.9755) and (-7.9528, 28.9528) .. (-7.9113, 28.9528).. 
  controls (-7.8788, 28.9528) and (-7.8512, 28.9665) .. (-7.8317, 28.9925) -- 
  (-7.8169, 29.0134).. controls (-7.8322, 28.9716) and (-7.8409, 28.9271) .. 
  (-7.8277, 28.8927) -- (-7.7835, 28.8475).. controls (-7.7549, 28.8361) and 
  (-7.728, 28.834) .. (-7.7078, 28.8356) -- (-7.7012, 28.8358) -- (-7.6914, 
  28.8258) -- (-7.6848, 28.8176) -- (-7.6748, 28.8149) -- (-7.6473, 28.8112).. 
  controls (-7.6295, 28.8112) and (-7.5763, 28.8163) .. (-7.5546, 28.879) -- 
  (-7.5454, 28.8723) -- (-7.5147, 28.8649) -- (-7.4626, 28.885) -- (-7.4549, 
  28.8901) -- (-7.3938, 28.8686).. controls (-7.3739, 28.8536) and (-7.3417, 
  28.8607) .. (-7.3163, 28.8882).. controls (-7.3025, 28.9028) and (-7.2713, 
  28.9451) .. (-7.2768, 29.0168).. controls (-7.2784, 29.039) and (-7.2816, 
  29.0642) .. (-7.2848, 29.0909).. controls (-7.2932, 29.1642) and (-7.3038, 
  29.2555) .. (-7.2885, 29.3041) -- (-7.2779, 29.3407).. controls (-7.2567, 
  29.4198) and (-7.2207, 29.5518) .. (-7.0567, 29.7452).. controls (-6.8744, 
  29.9603) and (-6.5839, 30.1146) .. (-6.4958, 30.1519) -- (-6.4733, 30.1521).. 
  controls (-6.2114, 30.1521) and (-4.6016, 29.9754) .. (-4.5855, 29.9735) -- 
  (-4.0291, 29.95).. controls (-4.0132, 29.945) and (-3.9613, 29.9302) .. 
  (-3.906, 29.9302).. controls (-3.8693, 29.9302) and (-3.8373, 29.9368) .. 
  (-3.8113, 29.95).. controls (-3.7822, 29.9553) and (-3.6203, 29.9831) .. 
  (-3.4414, 29.9831).. controls (-3.2943, 29.9831) and (-3.1742, 29.9648) .. 
  (-3.0848, 29.9283).. controls (-2.9718, 29.8828) and (-2.8781, 29.8569) .. 
  (-2.7898, 29.8471).. controls (-2.7667, 29.8447) and (-2.7424, 29.8431) .. 
  (-2.7173, 29.8431).. controls (-2.6247, 29.8431) and (-2.5321, 29.8603) .. 
  (-2.4426, 29.8767).. controls (-2.418, 29.8815) and (-2.3934, 29.8857) .. 
  (-2.3696, 29.8899).. controls (-2.2267, 29.9143) and (-2.1095, 29.9331) .. 
  (-2.001, 29.9497).. controls (-1.7179, 29.9921) and (-1.4833, 30.0177) .. 
  (-1.2626, 30.031).. controls (-1.1811, 30.036) and (-1.1015, 30.0389) .. 
  (-1.0255, 30.04) -- (-0.9618, 30.0405).. controls (-0.8083, 30.0405) and 
  (-0.6935, 30.0291) .. (-0.5895, 30.0032).. controls (-0.4826, 29.9762) and 
  (-0.3323, 29.918) .. (-0.2249, 29.7942).. controls (-0.1283, 29.6825) and 
  (-0.0881, 29.5349) .. (-0.1199, 29.4087).. controls (-0.1529, 29.2774) and 
  (-0.2641, 29.1584) .. (-0.4255, 29.0824).. controls (-0.6289, 28.9866) and 
  (-0.8771, 28.9702) .. (-1.0914, 29.0396).. controls (-1.1975, 29.0737) and 
  (-1.2798, 29.1234) .. (-1.3348, 29.1872).. controls (-1.3999, 29.2618) and 
  (-1.4261, 29.3592) .. (-1.4034, 29.4407).. controls (-1.3787, 29.5306) and 
  (-1.3028, 29.5962) .. (-1.2136, 29.6669) -- (-1.134, 29.7299) -- (-1.2356, 
  29.7264).. controls (-1.3496, 29.7227) and (-1.479, 29.7182) .. (-1.5952, 
  29.6719).. controls (-1.6962, 29.6314) and (-1.7682, 29.5629) .. (-1.8185, 
  29.4573).. controls (-1.8415, 29.4793) and (-1.8677, 29.4978) .. (-1.8918, 
  29.5148) -- (-1.9259, 29.5396).. controls (-1.9796, 29.5804) and (-2.037, 
  29.6171) .. (-2.0971, 29.6484).. controls (-2.1571, 29.6799) and (-2.2201, 
  29.7063) .. (-2.2844, 29.727) -- (-2.2976, 29.7309).. controls (-2.3379, 
  29.7447) and (-2.413, 29.7701) .. (-2.4905, 29.7701) -- (-2.5358, 29.7669) -- 
  (-2.6374, 29.7521) -- (-2.5466, 29.7042).. controls (-2.4895, 29.6743) and 
  (-2.4146, 29.6158) .. (-2.3982, 29.5793).. controls (-2.3802, 29.5396) and 
  (-2.3675, 29.5002) .. (-2.3606, 29.4661).. controls (-2.3921, 29.487) and 
  (-2.4225, 29.5118) .. (-2.4543, 29.5378).. controls (-2.4945, 29.5708) and 
  (-2.5363, 29.605) .. (-2.5815, 29.6314).. controls (-2.7194, 29.7103) and 
  (-2.889, 29.7325) .. (-3.0356, 29.6896) -- (-3.1237, 29.6637) -- (-3.0398, 
  29.6269).. controls (-2.9583, 29.5912) and (-2.88, 29.5476) .. (-2.8067, 
  29.4965).. controls (-2.7789, 29.4769) and (-2.7543, 29.4468) .. (-2.7633, 
  29.4319).. controls (-2.7683, 29.4237) and (-2.785, 29.419) .. (-2.8101, 
  29.4184) -- (-2.8191, 29.4184).. controls (-2.8821, 29.4184) and (-2.9424, 
  29.4319) .. (-3.0062, 29.4462).. controls (-3.0715, 29.4613) and (-3.139, 
  29.4767) .. (-3.211, 29.4767) -- (-3.2184, 29.4761).. controls (-3.3774, 
  29.4743) and (-3.5819, 29.4595) .. (-3.7539, 29.3655).. controls (-4.0584, 
  29.1999) and (-4.1825, 28.9951) .. (-4.1442, 28.7215).. controls (-4.0688, 
  28.186) and (-3.415, 28.1596) .. (-2.9377, 28.14).. controls (-2.849, 28.1365)
   and (-2.7652, 28.1331) .. (-2.6953, 28.1265).. controls (-2.6294, 28.1204) 
  and (-2.5739, 28.113) .. (-2.5133, 28.0804).. controls (-2.4548, 28.0495) and 
  (-2.399, 28.0061) .. (-2.3466, 27.9516).. controls (-2.146, 27.7431) and 
  (-1.8899, 27.727) .. (-1.8164, 27.727) -- (-1.7997, 27.7272).. controls 
  (-1.7915, 27.7264) and (-1.4973, 27.7021) .. (-1.3663, 27.4156) -- (-1.2906, 
  27.2502) -- (-1.3025, 27.4317).. controls (-1.3092, 27.5322) and (-1.3266, 
  27.6256) .. (-1.3544, 27.7095) -- (-1.3576, 27.7193) -- (-1.3721, 27.7616) -- 
  (-1.3367, 27.7352) -- (-1.2867, 27.6981).. controls (-1.248, 27.6735) and 
  (-1.2033, 27.6484) .. (-1.1665, 27.6312).. controls (-1.0996, 27.5997) and 
  (-1.0393, 27.5754) .. (-0.9615, 27.5587).. controls (-0.8898, 27.5431) and 
  (-0.8133, 27.5402) .. (-0.739, 27.5502).. controls (-0.6829, 27.5582) and 
  (-0.6265, 27.573) .. (-0.571, 27.5947).. controls (-0.49, 27.6267) and 
  (-0.4043, 27.6428) .. (-0.3154, 27.6428).. controls (-0.172, 27.6428) and 
  (-0.0696, 27.6002) .. (-0.0685, 27.5997) -- (-0.0005, 27.5706) -- (-0.0238, 
  27.641).. controls (-0.0265, 27.6489) and (-0.0926, 27.8336) .. (-0.5019, 
  27.8841) -- (-0.535, 27.8873) -- (-0.5855, 27.8934).. controls (-0.6514, 
  27.9093) and (-0.7181, 27.9434) .. (-0.7784, 27.9931) -- (-0.8451, 28.0556).. 
  controls (-0.8729, 28.0836) and (-0.9014, 28.1125) .. (-0.9353, 28.1373) -- 
  (-1.0022, 28.181) -- (-0.9887, 28.1836).. controls (-0.8972, 28.2043) and 
  (-0.7324, 28.2582) .. (-0.6591, 28.3879) -- (-0.6445, 28.4186) -- (-0.6204, 
  28.4784) -- (-0.6832, 28.4633).. controls (-0.7578, 28.4453) and (-0.8469, 
  28.44) .. (-0.9353, 28.4485).. controls (-1.0014, 28.4546) and (-1.0356, 
  28.4678) .. (-1.0866, 28.4876) -- (-1.1411, 28.5078).. controls (-1.1755, 
  28.5199) and (-1.2097, 28.5329) .. (-1.2441, 28.5461).. controls (-1.3737, 
  28.5956) and (-1.5081, 28.6475) .. (-1.651, 28.6498) -- (-1.6624, 28.6498).. 
  controls (-1.8346, 28.6498) and (-1.9944, 28.58) .. (-2.1489, 28.5125).. 
  controls (-2.2079, 28.4866) and (-2.2688, 28.4604) .. (-2.3291, 28.4382).. 
  controls (-2.5022, 28.3749) and (-2.6908, 28.3427) .. (-2.8895, 28.3427).. 
  controls (-3.0107, 28.3427) and (-3.1343, 28.3548) .. (-3.2568, 28.3786).. 
  controls (-3.5068, 28.4271) and (-3.7976, 28.5353) .. (-3.8642, 28.6935).. 
  controls (-3.8931, 28.762) and (-3.8804, 28.8361) .. (-3.8251, 28.9197).. 
  controls (-3.7857, 28.9798) and (-3.7245, 29.0311) .. (-3.6438, 29.0726).. 
  controls (-3.52, 29.1364) and (-3.3734, 29.1676) .. (-3.1954, 29.1676).. 
  controls (-3.1118, 29.1676) and (-3.02, 29.1605) .. (-2.9152, 29.1462).. 
  controls (-2.6151, 29.1057) and (-2.3164, 29.0269) .. (-2.027, 28.9507).. 
  controls (-1.919, 28.9224) and (-1.8105, 28.8935) .. (-1.7018, 28.8671).. 
  controls (-1.4306, 28.8004) and (-1.0925, 28.717) .. (-0.7723, 28.717).. 
  controls (-0.3876, 28.717) and (-0.108, 28.8358) .. (0.0828, 29.08).. controls
   (0.1336, 29.1449) and (0.1675, 29.2002) .. (0.1894, 29.2533).. controls 
  (0.2416, 29.3806) and (0.2834, 29.5714) .. (0.1855, 29.7579).. controls 
  (0.1463, 29.8333) and (0.1029, 29.9161) .. (0.0479, 29.9862).. controls 
  (0.0746, 30.0048) and (0.0992, 30.0294) .. (0.1212, 30.0601).. controls 
  (0.1521, 30.1032) and (0.1759, 30.1564) .. (0.1926, 30.218).. controls 
  (0.2021, 30.254) and (0.2088, 30.2932) .. (0.213, 30.3387) -- (0.2156, 
  30.3612).. controls (0.2191, 30.394) and (0.2233, 30.4313) .. (0.218, 30.4649)
   -- (0.2072, 30.53) -- (0.1487, 30.4699) -- (0.1146, 30.435) -- (0.0709, 
  30.3921).. controls (0.0151, 30.35) and (-0.0577, 30.3331) .. (-0.1283, 
  30.3162) -- (-0.1942, 30.3).. controls (-0.2352, 30.2887) and (-0.2736, 
  30.2781) .. (-0.3106, 30.2648) -- (-0.3466, 30.2482).. controls (-0.4027, 
  30.2688) and (-0.5956, 30.3318) .. (-0.9176, 30.3593).. controls (-0.8721, 
  30.3982) and (-0.7956, 30.453) .. (-0.6855, 30.4966) -- (-0.5985, 30.531) -- 
  (-0.6877, 30.5593).. controls (-0.6945, 30.5617) and (-0.8533, 30.6117) .. 
  (-1.0205, 30.6117).. controls (-1.1414, 30.6117) and (-1.2351, 30.5858) .. 
  (-1.3007, 30.5353) -- (-1.2909, 30.5562).. controls (-1.2737, 30.585) and 
  (-1.2425, 30.6048) .. (-1.1983, 30.6157) -- (-1.0819, 30.6437) -- (-1.1962, 
  30.6797).. controls (-1.1983, 30.6805) and (-1.252, 30.6974) .. (-1.3287, 
  30.6974).. controls (-1.3986, 30.6974) and (-1.4917, 30.6832) .. (-1.5814, 
  30.6255).. controls (-1.5605, 30.7117) and (-1.5367, 30.8464) .. (-1.5343, 
  31.0197).. controls (-1.5306, 31.3298) and (-1.5206, 31.4721) .. (-1.3219, 
  31.592).. controls (-1.2332, 31.6454) and (-1.1586, 31.6783) .. (-1.0872, 
  31.6947) -- (-1.0642, 31.6973) -- (-1.0168, 31.706).. controls (-0.9964, 
  31.7137) and (-0.97, 31.7328) .. (-0.9578, 31.7777).. controls (-0.9409, 
  31.8407) and (-0.9599, 31.9256) .. (-0.9848, 31.9767).. controls (-0.9586, 
  31.9899) and (-0.8948, 32.0132) .. (-0.7564, 32.0204).. controls (-0.6035, 
  32.0278) and (-0.5546, 32.1434) .. (-0.5151, 32.2363).. controls (-0.4821, 
  32.314) and (-0.4593, 32.3622) .. (-0.4075, 32.3715) -- (-0.3477, 32.3823) -- 
  (-0.3887, 32.427).. controls (-0.3934, 32.4323) and (-0.413, 32.4503) .. 
  (-0.4551, 32.4503).. controls (-0.4998, 32.4503) and (-0.5554, 32.4299) .. 
  (-0.621, 32.3897).. controls (-0.6535, 32.3696) and (-0.6853, 32.3596) .. 
  (-0.7157, 32.3596) -- (-0.7744, 32.3733).. controls (-0.6977, 32.4117) and 
  (-0.6075, 32.494) .. (-0.6046, 32.6347).. controls (-0.6003, 32.8289) and 
  (-0.5866, 32.8887) .. (-0.5863, 32.8895) -- (-0.5686, 32.9641) -- (-0.6355, 
  32.9263).. controls (-0.6382, 32.9247) and (-0.7017, 32.8882) .. (-0.7763, 
  32.798).. controls (-0.7956, 32.7742) and (-0.8205, 32.7604) .. (-0.8498, 
  32.7567).. controls (-0.8099, 32.8041) and (-0.7681, 32.8855) .. (-0.78, 
  33.0157).. controls (-0.7845, 33.0647) and (-0.7773, 33.0967) .. (-0.7533, 
  33.1335) -- (-0.7144, 33.1922) -- (-0.7845, 33.1851).. controls (-0.8168, 
  33.1816) and (-0.8496, 33.1639) .. (-0.8755, 33.1499) -- (-0.8795, 33.148).. 
  controls (-0.9194, 33.1261) and (-0.952, 33.1009) .. (-0.9766, 33.0723).. 
  controls (-1.0136, 33.1086) and (-1.0557, 33.1602) .. (-1.0591, 33.198) -- 
  (-1.0612, 33.2343).. controls (-1.0652, 33.3332) and (-1.0737, 33.5391) .. 
  (-1.2565, 33.5674) -- (-1.3142, 33.5724);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.1515, 158.812)}]
      \path[fill=c162c53,even odd rule] (0.0, 30.0).. controls (-0.068, 29.955) 
  and (-0.0915, 29.9381) .. (-0.1212, 29.9188).. controls (-0.1609, 29.8926) and
   (-0.1987, 29.8629) .. (-0.2323, 29.8291).. controls (-0.2686, 29.7923) and 
  (-0.3016, 29.7473) .. (-0.3112, 29.6957).. controls (-0.3112, 29.6957) and 
  (-0.214, 29.8084) .. (-0.0392, 29.7709).. controls (0.022, 29.7576) and 
  (0.0781, 29.786) .. (0.1318, 29.8114).. controls (0.0982, 29.7778) and 
  (0.0577, 29.7502) .. (0.0254, 29.7137).. controls (-0.0106, 29.6727) and 
  (-0.0667, 29.5621) .. (-0.0791, 29.4817).. controls (-0.0402, 29.5457) and 
  (0.004, 29.5679) .. (0.0312, 29.5812).. controls (0.0778, 29.6037) and 
  (0.1275, 29.6219) .. (0.1789, 29.6283).. controls (0.2921, 29.6418) and 
  (0.4884, 29.7518) .. (0.4993, 29.8518).. controls (0.4993, 29.8518) and 
  (0.607, 29.7923) .. (0.5315, 29.5875).. controls (0.5315, 29.5875) and 
  (0.7739, 29.6362) .. (0.7874, 29.8622).. controls (0.7874, 29.8622) and 
  (1.0268, 29.7008) .. (1.2073, 30.0643).. controls (1.2073, 30.0643) and 
  (1.1912, 30.0503) .. (1.0673, 30.0447).. controls (1.0673, 30.0447) and 
  (1.2287, 30.0966) .. (1.315, 30.3926).. controls (1.4012, 30.6887) and 
  (1.5251, 30.907) .. (1.7026, 30.8909).. controls (1.7026, 30.8909) and 
  (1.6462, 30.9689) .. (1.5116, 30.9716).. controls (1.5116, 30.9716) and 
  (1.5735, 31.6849) .. (2.0391, 31.6282).. controls (2.0391, 31.6282) and 
  (1.7727, 31.8034) .. (1.5412, 31.7441).. controls (1.5412, 31.7441) and 
  (1.5706, 31.9328) .. (1.3364, 32.1534).. controls (1.3364, 32.1534) and 
  (1.1964, 32.2826) .. (1.2745, 32.4818).. controls (1.2745, 32.4818) and 
  (1.1184, 32.3958) .. (1.1348, 32.2289) -- (0.8276, 32.7752).. controls 
  (0.8276, 32.7752) and (0.7387, 32.9636) .. (0.8115, 33.0525).. controls 
  (0.8115, 33.0525) and (0.6554, 32.9961) .. (0.7308, 32.6487).. controls 
  (0.7308, 32.6487) and (0.6292, 32.8617) .. (0.4778, 33.0848).. controls 
  (0.4098, 33.1848) and (0.3545, 33.2898) .. (0.3318, 33.4081) -- (0.2905, 
  33.3502).. controls (0.2749, 33.3245) and (0.2606, 33.2978) .. (0.2487, 
  33.27).. controls (0.2244, 33.2147) and (0.2212, 33.1552) .. (0.2043, 
  33.1009).. controls (0.1937, 33.144) and (0.1894, 33.1885) .. (0.1781, 
  33.2314).. controls (0.1712, 33.2576) and (0.1635, 33.284) .. (0.1537, 
  33.3097) -- (0.1212, 33.3745).. controls (0.1154, 33.3306) and (0.1207, 
  33.2933) .. (0.105, 33.2499).. controls (0.087, 33.2001) and (0.0566, 33.1554)
   .. (0.0201, 33.1171).. controls (-0.1093, 32.9826) and (-0.1979, 32.9099) .. 
  (-0.2492, 32.6487).. controls (-0.2492, 32.6487) and (-0.2998, 32.8392) .. 
  (-0.4649, 32.8789).. controls (-0.4649, 32.8789) and (-0.2289, 32.7387) .. 
  (-0.5432, 32.3863) -- (-0.5842, 32.3368).. controls (-0.5842, 32.3368) and 
  (-0.7636, 32.3069) .. (-0.8236, 32.0).. controls (-0.8403, 31.9087) and 
  (-0.8443, 31.8269) .. (-0.8252, 31.737).. controls (-0.8448, 31.7672) and 
  (-0.8707, 31.7931) .. (-0.9009, 31.8132).. controls (-0.9266, 31.8296) and 
  (-0.9551, 31.8415) .. (-0.9848, 31.8479) -- (-1.0411, 31.8547) -- (-1.0999, 
  31.8494).. controls (-0.9824, 31.8142) and (-0.9131, 31.7116) .. (-0.916, 
  31.5891).. controls (-0.9213, 31.369) and (-0.8506, 31.2388) .. (-0.7826, 
  31.1787).. controls (-0.7826, 31.1787) and (-1.0112, 31.2576) .. (-1.1605, 
  31.157).. controls (-1.1605, 31.157) and (-0.962, 31.225) .. (-0.8506, 
  30.8525).. controls (-0.8506, 30.8525) and (-0.9406, 30.8427) .. (-0.9925, 
  30.9364).. controls (-0.9925, 30.9364) and (-0.9623, 30.6403) .. (-0.4905, 
  30.4511).. controls (-0.4905, 30.4511) and (-0.5474, 30.4344) .. (-0.6043, 
  30.4461).. controls (-0.6043, 30.4461) and (-0.5157, 30.3223) .. (-0.4405, 
  30.299).. controls (-0.4405, 30.299) and (-0.4905, 30.2521) .. (-0.5792, 
  30.2421) -- (-0.5109, 30.1704).. controls (-0.4871, 30.1505) and (-0.4612, 
  30.1331) .. (-0.4329, 30.1199).. controls (-0.4043, 30.1066) and (-0.3699, 
  30.1074) .. (-0.3424, 30.095) -- (-0.3802, 30.0743).. controls (-0.4268, 
  30.0614) and (-0.4688, 30.0736) .. (-0.5151, 30.073) -- (-0.4932, 30.0439).. 
  controls (-0.4694, 30.0193) and (-0.4416, 29.9989) .. (-0.4114, 29.9825).. 
  controls (-0.3516, 29.9503) and (-0.2842, 29.9376) .. (-0.2167, 29.9394).. 
  controls (-0.1831, 29.9402) and (-0.1498, 29.9447) .. (-0.1167, 29.9513).. 
  controls (-0.0873, 29.9577) and (-0.0299, 29.9979) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.9011, 155.0916)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (0.036, 30.1146) -- 
  (0.0529, 30.186).. controls (0.0598, 30.2193) and (0.0659, 30.2508) .. 
  (0.0791, 30.2807).. controls (0.0894, 30.3043) and (0.1019, 30.3283) .. 
  (0.1167, 30.3535).. controls (0.1426, 30.2693) and (0.186, 30.1836) .. 
  (0.2498, 30.0897).. controls (0.3979, 29.8717) and (0.4993, 29.6603) .. 
  (0.5006, 29.6582) -- (0.6242, 29.3989) -- (0.5633, 29.6796).. controls 
  (0.5379, 29.796) and (0.54, 29.8767) .. (0.5527, 29.932).. controls (0.5628, 
  29.8603) and (0.5916, 29.7968) .. (0.5972, 29.7849) -- (0.9829, 29.098) -- 
  (0.9676, 29.2557).. controls (0.961, 29.324) and (0.988, 29.3772) .. (1.0184, 
  29.4139).. controls (1.0044, 29.2557) and (1.1083, 29.1576) .. (1.1136, 
  29.1525).. controls (1.3301, 28.9485) and (1.3089, 28.78) .. (1.3078, 28.7729)
   -- (1.301, 28.7234) -- (1.3491, 28.7358).. controls (1.3782, 28.743) and 
  (1.4097, 28.7467) .. (1.4428, 28.7467).. controls (1.5412, 28.7467) and 
  (1.6396, 28.7136) .. (1.7111, 28.6818).. controls (1.3359, 28.6112) and 
  (1.2803, 28.0246) .. (1.2782, 27.9984) -- (1.275, 27.9627) -- (1.3107, 
  27.9619).. controls (1.3555, 27.9609) and (1.3904, 27.9505) .. (1.4163, 
  27.9384).. controls (1.2814, 27.896) and (1.1695, 27.7243) .. (1.0827, 
  27.4259).. controls (1.0025, 27.1499) and (0.8583, 27.1007) .. (0.8567, 
  27.1002) -- (0.6199, 27.0242) -- (0.8684, 27.0351).. controls (0.8983, 
  27.0364) and (0.9226, 27.0383) .. (0.9422, 27.0404).. controls (0.8774, 
  26.9374) and (0.7996, 26.8837) .. (0.7152, 26.8837).. controls (0.6522, 
  26.8837) and (0.6064, 26.9136) .. (0.6059, 26.9136) -- (0.5575, 26.9464) -- 
  (0.5538, 26.888).. controls (0.5458, 26.7554) and (0.4471, 26.6914) .. 
  (0.3818, 26.6633).. controls (0.4231, 26.8425) and (0.3201, 26.902) .. 
  (0.3151, 26.9046) -- (0.2712, 26.9287) -- (0.2659, 26.879).. controls (0.2577,
   26.8041) and (0.0828, 26.698) .. (-0.0254, 26.685).. controls (-0.0743, 
  26.6792) and (-0.1246, 26.6631) .. (-0.1836, 26.6348) -- (-0.2045, 26.6242).. 
  controls (-0.186, 26.6636) and (-0.1648, 26.698) .. (-0.1498, 26.7152) -- 
  (-0.0915, 26.7694) -- (-0.045, 26.8112) -- (0.0939, 26.9488) -- (-0.0886, 
  26.8626).. controls (-0.136, 26.8398) and (-0.1865, 26.8173) .. (-0.2323, 
  26.8274).. controls (-0.3029, 26.8425) and (-0.3717, 26.834) .. (-0.4212, 
  26.816) -- (-0.4085, 26.8295).. controls (-0.3789, 26.8594) and (-0.3434, 
  26.888) .. (-0.3032, 26.9144) -- (-0.2638, 26.9406).. controls (-0.2447, 
  26.9536) and (-0.2204, 26.97) .. (-0.1818, 26.9959) -- (-0.0767, 27.065) -- 
  (-0.2024, 27.0568).. controls (-0.2257, 27.0552) and (-0.2524, 27.0417) .. 
  (-0.2802, 27.0274) -- (-0.3239, 27.0078).. controls (-0.3572, 27.0009) and 
  (-0.3881, 26.9972) .. (-0.4178, 26.9965) -- (-0.4294, 26.9965).. controls 
  (-0.4913, 26.9965) and (-0.5472, 27.0094) .. (-0.5956, 27.0356) -- (-0.6324, 
  27.0589) -- (-0.5715, 27.066) -- (-0.5413, 27.0811) -- (-0.5305, 27.0875) -- 
  (-0.4567, 27.1166) -- (-0.5292, 27.1491) -- (-0.58, 27.1631) -- (-0.6191, 
  27.174) -- (-0.6898, 27.2198) -- (-0.7072, 27.2393) -- (-0.7131, 27.246).. 
  controls (-0.6535, 27.2655) and (-0.6197, 27.2965) .. (-0.6178, 27.2981) -- 
  (-0.5757, 27.3375) -- (-0.6308, 27.3544).. controls (-0.6623, 27.3642) and 
  (-0.7011, 27.4002) .. (-0.7318, 27.4338).. controls (-0.703, 27.4367) and 
  (-0.6826, 27.4425) .. (-0.6816, 27.4428) -- (-0.589, 27.4698) -- (-0.6784, 
  27.5058).. controls (-0.9459, 27.6129) and (-1.0655, 27.7561) .. (-1.1184, 
  27.8532).. controls (-1.0753, 27.8376) and (-1.0472, 27.8431) .. (-1.0472, 
  27.8431) -- (-1.0081, 27.8476) -- (-1.0189, 27.8857).. controls (-1.0755, 
  28.0749) and (-1.1554, 28.159) .. (-1.2256, 28.1947) -- (-1.1684, 28.1985).. 
  controls (-1.0753, 28.1985) and (-0.9946, 28.1709) .. (-0.9938, 28.1709) -- 
  (-0.8342, 28.1162) -- (-0.961, 28.2276).. controls (-0.9996, 28.2614) and 
  (-1.0888, 28.367) .. (-1.0827, 28.612).. controls (-1.0808, 28.699) and 
  (-1.1115, 28.7766) .. (-1.1665, 28.8319) -- (-1.1195, 28.8086).. controls 
  (-1.0933, 28.7916) and (-1.0705, 28.7689) .. (-1.0536, 28.7424) -- (-0.9554, 
  28.5887) -- (-0.9927, 28.7673).. controls (-1.0094, 28.8462) and (-1.0089, 
  28.9208) .. (-0.9909, 29.0173).. controls (-0.9369, 29.2946) and (-0.785, 
  29.3264) .. (-0.7787, 29.3277) -- (-0.7668, 29.3301) -- (-0.7176, 29.3891).. 
  controls (-0.5892, 29.5327) and (-0.5323, 29.6632) .. (-0.5495, 29.7748) -- 
  (-0.5535, 29.7949).. controls (-0.5017, 29.7354) and (-0.4818, 29.6648) .. 
  (-0.4815, 29.664) -- (-0.4442, 29.5251) -- (-0.4167, 29.6658).. controls 
  (-0.3715, 29.896) and (-0.2982, 29.9714) .. (-0.1873, 30.0855) -- (-0.1558, 
  30.1175).. controls (-0.1132, 30.1622) and (-0.0823, 30.2109) .. (-0.0638, 
  30.2622) -- (-0.0609, 30.2707) -- (-0.0542, 30.2466) -- (-0.041, 30.1807) -- 
  (-0.0283, 30.1167) -- cycle(-0.0947, 30.5294) -- (-0.1119, 30.403) -- 
  (-0.1156, 30.3561).. controls (-0.1172, 30.3305) and (-0.1183, 30.3085) .. 
  (-0.1267, 30.285).. controls (-0.1421, 30.2424) and (-0.168, 30.2019) .. 
  (-0.2043, 30.164) -- (-0.2352, 30.132).. controls (-0.3336, 30.0307) and 
  (-0.4085, 29.9537) .. (-0.4588, 29.7772).. controls (-0.4945, 29.8389) and 
  (-0.5567, 29.9108) .. (-0.6572, 29.9352) -- (-0.8715, 29.9865) -- (-0.6821, 
  29.8738).. controls (-0.68, 29.8727) and (-0.6265, 29.8389) .. (-0.6154, 
  29.7635).. controls (-0.6022, 29.6738) and (-0.6551, 29.5592) .. (-0.7684, 
  29.4322) -- (-0.8033, 29.3901).. controls (-0.8496, 29.3766) and (-1.002, 
  29.311) .. (-1.0565, 29.0298).. controls (-1.0684, 28.9665) and (-1.0732, 
  28.9104) .. (-1.071, 28.8565) -- (-1.0829, 28.8647).. controls (-1.112, 
  28.8835) and (-1.1438, 28.897) .. (-1.1779, 28.9046) -- (-1.2406, 28.912) -- 
  (-1.2454, 28.912) -- (-1.3052, 28.9062) -- (-1.4504, 28.8829) -- (-1.3097, 
  28.8411).. controls (-1.2081, 28.8107) and (-1.1467, 28.7239) .. (-1.1496, 
  28.6138).. controls (-1.1538, 28.4398) and (-1.1126, 28.3268) .. (-1.0702, 
  28.2572).. controls (-1.0993, 28.262) and (-1.1329, 28.2651) .. (-1.1684, 
  28.2651).. controls (-1.2525, 28.2651) and (-1.3234, 28.2461) .. (-1.3795, 
  28.2085) -- (-1.5894, 28.067) -- (-1.3499, 28.149) -- (-1.3237, 28.1522).. 
  controls (-1.2803, 28.1522) and (-1.1761, 28.1281) .. (-1.0999, 27.9177).. 
  controls (-1.1216, 27.9262) and (-1.1451, 27.9431) .. (-1.1634, 27.9762) -- 
  (-1.2425, 28.1188) -- (-1.2258, 27.9564).. controls (-1.2248, 27.945) and 
  (-1.1962, 27.7037) .. (-0.8514, 27.5137) -- (-0.8813, 27.5198) -- (-0.8319, 
  27.4502).. controls (-0.8242, 27.4396) and (-0.7697, 27.3653) .. (-0.7067, 
  27.3203).. controls (-0.7263, 27.3113) and (-0.7522, 27.3026) .. (-0.7832, 
  27.2989) -- (-0.7795, 27.2655) -- (-0.7964, 27.2375) -- (-0.7575, 27.1952) -- 
  (-0.7326, 27.1687) -- (-0.676, 27.1287) -- (-0.7131, 27.1301) -- (-0.7795, 
  27.1301) -- (-0.7363, 27.0684) -- (-0.7173, 27.0443).. controls (-0.6916, 
  27.0179) and (-0.6612, 26.9951) .. (-0.6273, 26.9766).. controls (-0.5691, 
  26.9454) and (-0.5024, 26.9298) .. (-0.4294, 26.9298) -- (-0.4159, 26.9298) --
   (-0.395, 26.9306) -- (-0.4561, 26.8763).. controls (-0.5061, 26.8258) and 
  (-0.535, 26.7763) .. (-0.5442, 26.725) -- (-0.5659, 26.6041) -- (-0.4858, 
  26.6975).. controls (-0.4837, 26.7001) and (-0.422, 26.7689) .. (-0.3096, 
  26.7689) -- (-0.2463, 26.7618) -- (-0.2011, 26.7578).. controls (-0.2434, 
  26.7091) and (-0.2995, 26.5938) .. (-0.3125, 26.5107) -- (-0.3381, 26.3437) --
   (-0.2508, 26.4882).. controls (-0.2162, 26.5448) and (-0.1775, 26.5636) .. 
  (-0.1545, 26.5747).. controls (-0.1024, 26.5998) and (-0.0587, 26.6139) .. 
  (-0.0172, 26.6186).. controls (0.0788, 26.6303) and (0.2498, 26.7115) .. 
  (0.3106, 26.8118).. controls (0.3262, 26.7798) and (0.3363, 26.7213) .. (0.3, 
  26.6229) -- (0.2794, 26.5668) -- (0.3379, 26.5787).. controls (0.4225, 
  26.5959) and (0.5789, 26.6705) .. (0.6141, 26.8358).. controls (0.6395, 
  26.8263) and (0.6744, 26.8171) .. (0.7152, 26.8171).. controls (0.8041, 
  26.8171) and (0.9319, 26.8615) .. (1.0372, 27.0729) -- (1.1118, 27.2237) -- 
  (0.9999, 27.1261).. controls (1.0507, 27.1817) and (1.107, 27.2698) .. (1.147,
   27.4071).. controls (1.2118, 27.6304) and (1.3266, 27.8976) .. (1.4994, 
  27.8812) -- (1.5727, 27.8746) -- (1.5296, 27.9339).. controls (1.5269, 
  27.9373) and (1.4724, 28.0111) .. (1.3488, 28.0262).. controls (1.3674, 
  28.1566) and (1.4565, 28.6221) .. (1.7873, 28.6221) -- (1.8349, 28.6189) -- 
  (1.9764, 28.6019) -- (1.8574, 28.68).. controls (1.8489, 28.6856) and (1.6515,
   28.8136) .. (1.4428, 28.8136) -- (1.375, 28.8086).. controls (1.3705, 
  28.8819) and (1.3372, 29.0337) .. (1.1591, 29.2015).. controls (1.1541, 
  29.2063) and (1.0372, 29.3187) .. (1.1054, 29.4933) -- (1.1393, 29.5796) -- 
  (1.0581, 29.5346).. controls (1.0528, 29.532) and (0.9493, 29.4732) .. 
  (0.9128, 29.3594) -- (0.6567, 29.8153).. controls (0.6355, 29.8603) and 
  (0.5887, 29.9958) .. (0.6371, 30.055) -- (0.7141, 30.1487) -- (0.6001, 
  30.1077).. controls (0.594, 30.1056) and (0.4784, 30.0606) .. (0.4768, 
  29.8471).. controls (0.4329, 29.9262) and (0.3741, 30.0262) .. (0.3051, 
  30.1275).. controls (0.2281, 30.2405) and (0.1834, 30.3395) .. (0.1643, 
  30.4379) -- (0.1511, 30.5056) -- (0.1061, 30.4535) -- (0.0616, 30.3913).. 
  controls (0.0442, 30.3625) and (0.0299, 30.335) .. (0.0177, 30.3072) -- 
  (0.0066, 30.2775).. controls (-0.0003, 30.3027) and (-0.0077, 30.3249) .. 
  (-0.0153, 30.3453) -- (-0.0339, 30.3829) -- (-0.0479, 30.4106) -- (-0.0947, 
  30.5294);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.2694, 156.4687)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1241, 30.2265) .. (0.0484, 30.5935).. controls (0.0484, 30.5935) and 
  (0.3037, 30.2564) .. (0.0794, 29.8812) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.2958, 156.6162)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0386, 29.9497) -- 
  (0.0659, 29.891).. controls (0.0849, 29.8455) and (0.096, 29.7968) .. (0.1058,
   29.7486).. controls (0.1117, 29.7193) and (0.1185, 29.6939) .. (0.1347, 
  29.6682).. controls (0.1513, 29.642) and (0.1722, 29.6193) .. (0.1926, 
  29.5965).. controls (0.2167, 29.569) and (0.344, 29.4399) .. (0.3868, 
  29.4952).. controls (0.3868, 29.4952) and (0.3657, 29.5894) .. (0.3868, 
  29.6428) -- (0.3252, 29.6362).. controls (0.277, 29.6381) and (0.2315, 
  29.6571) .. (0.1961, 29.6894).. controls (0.172, 29.7111) and (0.1516, 
  29.7386) .. (0.1368, 29.768).. controls (0.1207, 29.7994) and (0.114, 29.833) 
  .. (0.1016, 29.8661).. controls (0.0918, 29.8926) and (0.0802, 29.9182) .. 
  (0.064, 29.9418).. controls (0.0466, 29.9667) and (0.0251, 29.9833) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.8123, 157.0187)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.4384, 30.2262) .. (-0.1556, 30.7985).. controls (-0.1556, 30.7985) and 
  (-0.2985, 30.3307) .. (0.0212, 30.1453) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.0321, 158.3225)}]
      \path[fill=ce3aa36,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0259, 29.9249) .. (-0.0675, 29.9042).. controls (-0.0675, 29.9042) and 
  (0.091, 29.9249) .. (0.1222, 29.9767).. controls (0.1222, 29.9767) and 
  (0.1169, 29.8571) .. (0.0754, 29.8106).. controls (0.0754, 29.8106) and 
  (0.1924, 29.8262) .. (0.2207, 29.9053) -- (0.2061, 29.8354).. controls 
  (0.2061, 29.8354) and (0.3117, 29.8921) .. (0.3262, 29.9817).. controls 
  (0.3262, 29.9817) and (0.4172, 29.9212) .. (0.5638, 29.9595).. controls 
  (0.5638, 29.9595) and (0.5006, 29.9714) .. (0.4755, 30.0148).. controls 
  (0.4755, 30.0148) and (0.626, 30.0463) .. (0.6906, 30.2839).. controls 
  (0.7551, 30.5212) and (0.726, 30.5842) .. (0.7414, 30.6564).. controls 
  (0.7567, 30.7284) and (0.7498, 30.7721) .. (0.7956, 30.885).. controls 
  (0.7956, 30.885) and (0.8361, 30.9861) .. (0.7956, 31.1306).. controls 
  (0.7956, 31.1306) and (0.8022, 31.0911) .. (0.766, 31.0575) -- (0.7464, 
  31.0337).. controls (0.7464, 31.0337) and (0.767, 31.1578) .. (0.721, 
  31.2136).. controls (0.6747, 31.2697) and (0.5641, 31.4338) .. (0.5641, 
  31.4338).. controls (0.5641, 31.4338) and (0.4059, 31.6592) .. (0.4059, 
  31.7063).. controls (0.4059, 31.7537) and (0.4167, 31.8926) .. (0.395, 
  31.9264).. controls (0.395, 31.9264) and (0.3561, 32.0214) .. (0.277, 
  32.0847).. controls (0.277, 32.0847) and (0.3254, 32.0384) .. (0.2892, 
  31.901).. controls (0.2892, 31.901) and (0.2686, 32.014) .. (0.1955, 
  32.0677).. controls (0.1225, 32.1212) and (0.0992, 32.1164) .. (0.0908, 
  32.1685).. controls (0.0908, 32.1685) and (0.0569, 32.1286) .. (0.0664, 
  32.0468).. controls (0.0762, 31.9656) and (0.0519, 31.9375) .. (0.0519, 
  31.9375).. controls (0.0519, 31.9375) and (0.0106, 31.9997) .. (0.0021, 
  32.0664).. controls (0.0021, 32.0664) and (-0.0746, 32.0106) .. (-0.0577, 
  31.8828).. controls (-0.0577, 31.8828) and (-0.122, 31.9278) .. (-0.1087, 
  32.0545).. controls (-0.1087, 32.0545) and (-0.2545, 32.0555) .. (-0.2244, 
  31.7854).. controls (-0.2244, 31.7854) and (-0.217, 31.7939) .. (-0.2596, 
  31.6759) -- (-0.427, 31.1737).. controls (-0.427, 31.1737) and (-0.481, 
  31.2785) .. (-0.4569, 31.3769).. controls (-0.4569, 31.3769) and (-0.5249, 
  31.3187) .. (-0.5141, 31.0819).. controls (-0.5141, 31.0819) and (-0.5477, 
  31.1541) .. (-0.5636, 31.1877).. controls (-0.5636, 31.1877) and (-0.5575, 
  31.0975) .. (-0.585, 31.0038).. controls (-0.6125, 30.9102) and (-0.5575, 
  30.7541) .. (-0.5575, 30.7541).. controls (-0.5575, 30.7541) and (-0.4591, 
  30.5231) .. (-0.4553, 30.468).. controls (-0.427, 30.3601) and (-0.3924, 
  30.2487) .. (-0.3384, 30.1505).. controls (-0.2762, 30.0381) and (-0.1296, 
  29.8995) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.9719, 155.9693)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (0.0288, 30.0331).. 
  controls (0.0344, 30.0397) and (0.0622, 30.0767) .. (0.0513, 30.1683) -- 
  (0.0505, 30.2096) -- (0.0775, 30.1916) -- (0.1273, 30.1582).. controls 
  (0.1884, 30.1135) and (0.2077, 30.0135) .. (0.208, 30.0124) -- (0.2352, 
  29.8669) -- (0.2731, 30.0101).. controls (0.2807, 30.0384) and (0.2847, 
  30.0632) .. (0.2865, 30.0855).. controls (0.3059, 30.055) and (0.3154, 
  30.0318) .. (0.3156, 30.0312) -- (0.3186, 30.0262).. controls (0.3302, 
  30.0061) and (0.3265, 29.9037) .. (0.3252, 29.8653) -- (0.3244, 29.8238).. 
  controls (0.3244, 29.7735) and (0.427, 29.6195) .. (0.4884, 29.5322).. 
  controls (0.4927, 29.5259) and (0.6003, 29.3666) .. (0.6469, 29.31).. controls
   (0.6765, 29.274) and (0.6699, 29.1848) .. (0.6652, 29.1565) -- (0.6451, 
  29.0329) -- (0.7313, 29.1388).. controls (0.7347, 29.0634) and (0.7165, 
  29.0152) .. (0.7162, 29.0147).. controls (0.6826, 28.9316) and (0.676, 
  28.8837) .. (0.6697, 28.8377) -- (0.6604, 28.7808).. controls (0.6548, 
  28.7538) and (0.6543, 28.7289) .. (0.6541, 28.7001).. controls (0.6533, 
  28.6437) and (0.6525, 28.566) .. (0.6101, 28.4101).. controls (0.5522, 
  28.1974) and (0.4252, 28.1662) .. (0.4199, 28.1649) -- (0.376, 28.1545) -- 
  (0.3982, 28.1156) -- (0.4109, 28.0976).. controls (0.3392, 28.0998) and 
  (0.2969, 28.127) .. (0.2963, 28.127) -- (0.2535, 28.1548) -- (0.245, 
  28.1045).. controls (0.2405, 28.0767) and (0.2244, 28.0524) .. (0.2058, 
  28.0323) -- (0.208, 28.2196) -- (0.141, 28.0339) -- (0.0897, 27.9828).. 
  controls (0.1042, 28.0331) and (0.1066, 28.0842) .. (0.1072, 28.0929) -- 
  (0.113, 28.2241) -- (0.0452, 28.1114).. controls (0.0373, 28.0982) and 
  (0.0069, 28.0847) .. (-0.0307, 28.0736) -- (-0.0167, 28.1066) -- (0.0198, 
  28.2122) -- (-0.0688, 28.1439).. controls (-0.0929, 28.1252) and (-0.1175, 
  28.1162) .. (-0.1442, 28.1162).. controls (-0.227, 28.1162) and (-0.313, 
  28.2035) .. (-0.3575, 28.2844).. controls (-0.4117, 28.3823) and (-0.445, 
  28.4943) .. (-0.4707, 28.5914).. controls (-0.4776, 28.6535) and (-0.5585, 
  28.8459) .. (-0.5752, 28.8845).. controls (-0.5887, 28.9234) and (-0.6215, 
  29.0438) .. (-0.6014, 29.1121) -- (-0.5871, 29.1732) -- (-0.5215, 29.0324) -- 
  (-0.5292, 29.2007).. controls (-0.5315, 29.2526) and (-0.53, 29.2949) .. 
  (-0.5263, 29.3295).. controls (-0.5165, 29.2986) and (-0.5061, 29.278) .. 
  (-0.5051, 29.2761) -- (-0.4686, 29.2057) -- (-0.2762, 29.7828).. controls 
  (-0.2397, 29.8838) and (-0.2347, 29.9021) .. (-0.2402, 29.9145).. controls 
  (-0.2521, 30.0307) and (-0.2283, 30.0855) .. (-0.2061, 30.1111) -- (-0.1921, 
  30.1244).. controls (-0.1871, 30.0175) and (-0.1278, 29.9749) .. (-0.1251, 
  29.973) -- (-0.0627, 29.9294) -- (-0.0728, 30.0045).. controls (-0.0788, 
  30.0503) and (-0.0714, 30.0844) .. (-0.0609, 30.1087).. controls (-0.045, 
  30.068) and (-0.0254, 30.0384) .. (-0.0243, 30.0365) -- cycle(0.0638, 30.3627)
   -- (0.0169, 30.3077).. controls (0.0135, 30.3037) and (-0.0116, 30.272) .. 
  (-0.0161, 30.2125) -- (-0.0204, 30.2442) -- (-0.0661, 30.2109).. controls 
  (-0.0683, 30.209) and (-0.1037, 30.1828) .. (-0.1251, 30.1278) -- (-0.1238, 
  30.1683) -- (-0.1199, 30.2051) -- (-0.1572, 30.2051).. controls (-0.1625, 
  30.2051) and (-0.213, 30.204) .. (-0.2548, 30.1569).. controls (-0.3016, 
  30.1048) and (-0.3188, 30.0188) .. (-0.3061, 29.9024).. controls (-0.3082, 
  29.8942) and (-0.3156, 29.8704) .. (-0.3392, 29.8047) -- (-0.4744, 29.3991).. 
  controls (-0.4789, 29.4266) and (-0.4797, 29.4568) .. (-0.4725, 29.4862) -- 
  (-0.4477, 29.587) -- (-0.5268, 29.5198).. controls (-0.5331, 29.5142) and 
  (-0.5771, 29.4724) .. (-0.5921, 29.342) -- (-0.6564, 29.4809) -- (-0.6451, 
  29.3028).. controls (-0.6451, 29.302) and (-0.64, 29.2174) .. (-0.6654, 
  29.1306).. controls (-0.6959, 29.0277) and (-0.6398, 28.8671) .. (-0.6374, 
  28.8602).. controls (-0.5993, 28.7713) and (-0.5392, 28.6194) .. (-0.5368, 
  28.5834) -- (-0.536, 28.5771).. controls (-0.5093, 28.4752) and (-0.4741, 
  28.3569) .. (-0.4159, 28.2522).. controls (-0.3585, 28.1479) and (-0.2469, 
  28.0442) .. (-0.1339, 28.0498) -- (-0.3082, 27.9624) -- (-0.1114, 27.9881).. 
  controls (-0.0857, 27.9915) and (-0.0217, 28.0019) .. (0.0312, 28.0241).. 
  controls (0.0249, 27.9942) and (0.0153, 27.9651) .. (0.0021, 27.9503) -- 
  (-0.0577, 27.8831) -- (0.0315, 27.895).. controls (0.0355, 27.8955) and 
  (0.1066, 27.9053) .. (0.1588, 27.9484) -- (0.1736, 27.9233).. controls 
  (0.1778, 27.9254) and (0.2638, 27.9725) .. (0.2987, 28.0524).. controls 
  (0.3262, 28.0418) and (0.3678, 28.0307) .. (0.4202, 28.0307).. controls 
  (0.454, 28.0307) and (0.489, 28.0352) .. (0.5239, 28.0442) -- (0.6681, 28.082)
   -- (0.5218, 28.1098) -- (0.4879, 28.1217).. controls (0.544, 28.1535) and 
  (0.6294, 28.2268) .. (0.6744, 28.3927).. controls (0.7191, 28.5567) and 
  (0.7202, 28.6392) .. (0.721, 28.6993).. controls (0.7213, 28.726) and (0.7215,
   28.7467) .. (0.7258, 28.7668) -- (0.7358, 28.8284).. controls (0.7419, 
  28.8726) and (0.7477, 28.9144) .. (0.7781, 28.9901).. controls (0.78, 28.9946)
   and (0.8223, 29.1033) .. (0.7795, 29.2568) -- (0.735, 29.2465).. controls 
  (0.7318, 29.284) and (0.722, 29.3237) .. (0.6985, 29.3526).. controls (0.6538,
   29.4065) and (0.5445, 29.5682) .. (0.5435, 29.5698).. controls (0.4723, 
  29.6711) and (0.394, 29.7971) .. (0.3911, 29.8246) -- (0.3921, 29.8629).. 
  controls (0.3953, 29.9529) and (0.3958, 30.0249) .. (0.3765, 30.0593).. 
  controls (0.3694, 30.0754) and (0.3281, 30.1654) .. (0.2495, 30.2281) -- 
  (0.2056, 30.1781) -- (0.2111, 30.1677) -- (0.167, 30.2122) -- (0.113, 
  30.2484).. controls (0.0818, 30.2678) and (0.0791, 30.2693) .. (0.0754, 
  30.2916) -- (0.0638, 30.3627);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.0412, 158.1045)}]
      \path[fill=ce5ae4a,even odd rule] (0.0, 30.0) -- (-0.0463, 29.9079).. 
  controls (-0.0606, 29.846) and (-0.0362, 29.7804) .. (0.0037, 29.7328).. 
  controls (0.0513, 29.6756) and (0.1093, 29.6706) .. (0.1794, 29.6854).. 
  controls (0.1794, 29.6854) and (0.2323, 29.6965) .. (0.2712, 29.733).. 
  controls (0.2712, 29.733) and (0.1934, 29.7643) .. (0.1074, 29.8801).. 
  controls (0.1074, 29.8801) and (0.1707, 29.8674) .. (0.2212, 29.8852).. 
  controls (0.2212, 29.8852) and (0.0796, 29.9399) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.8917, 158.465)}]
      \path[fill=black,nonzero rule] (0.0, 30.0).. controls (-0.0378, 30.0) and 
  (-0.0659, 30.0132) .. (-0.0905, 30.0426).. controls (-0.1281, 30.0878) and 
  (-0.1442, 30.1426) .. (-0.1336, 30.1889) -- (-0.1106, 30.2416) -- (-0.0609, 
  30.2125) -- (-0.0905, 30.218) -- (-0.0392, 30.1487).. controls (0.0093, 
  30.0836) and (0.0558, 30.0434) .. (0.0892, 30.0196) -- (0.0527, 30.0066) -- 
  (0.0, 30.0)(-0.1204, 30.322).. controls (-0.164, 30.322) and (-0.1984, 
  30.2051) .. (-0.1987, 30.204).. controls (-0.214, 30.1373) and (-0.1929, 
  30.0611) .. (-0.1418, 30.0).. controls (-0.1042, 29.955) and (-0.0579, 
  29.9333) .. (0.0, 29.9333).. controls (0.0201, 29.9333) and (0.0418, 29.936) 
  .. (0.0667, 29.941).. controls (0.0691, 29.9415) and (0.1291, 29.9548) .. 
  (0.1744, 29.9968) -- (0.213, 30.0325) -- (0.1643, 30.0524).. controls (0.1638,
   30.0524) and (0.1193, 30.0717) .. (0.0622, 30.1318) -- (0.1124, 30.1421) -- 
  (0.1979, 30.172) -- (0.1135, 30.2048).. controls (0.1122, 30.2051) and 
  (-0.0246, 30.259) .. (-0.0995, 30.3151) -- (-0.1085, 30.322) -- (-0.1204, 
  30.322);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.072, 158.2312)}]
      \path[fill=ce5ae4a,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1873, 30.1106) .. (0.2373, 30.1947).. controls (0.2373, 30.1947) and 
  (0.3225, 30.0598) .. (0.2172, 29.9444).. controls (0.1122, 29.8293) and 
  (0.014, 29.9582) .. (0.014, 29.9582) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.0247, 158.2517)}]
      \path[fill=black,nonzero rule] (0.0, 30.0).. controls (0.0421, 30.0262) 
  and (0.1331, 30.086) .. (0.191, 30.1466).. controls (0.2029, 30.1048) and 
  (0.2074, 30.041) .. (0.155, 29.9833).. controls (0.1326, 29.959) and (0.1095, 
  29.9463) .. (0.0868, 29.9463).. controls (0.0407, 29.9463) and (0.0032, 
  29.9942) .. (0.0029, 29.9944) -- (0.0, 30.0)(0.1984, 30.2752) -- (0.1707, 
  30.2281).. controls (0.1334, 30.1651) and (-0.0048, 30.0743) .. (-0.0548, 
  30.0447) -- (-0.0656, 30.0386) -- (-0.0696, 30.0265) -- (-0.0519, 29.9566).. 
  controls (-0.0479, 29.9513) and (0.0074, 29.8794) .. (0.0868, 29.8794).. 
  controls (0.1291, 29.8794) and (0.1685, 29.8992) .. (0.2043, 29.9384).. 
  controls (0.3011, 30.0442) and (0.2619, 30.1749) .. (0.2275, 30.2291) -- 
  (0.1984, 30.2752);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.3452, 159.2168)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0868, 30.2029) .. (-0.0339, 30.3141).. controls (-0.1548, 30.4249) and 
  (-0.1532, 30.5781) .. (-0.1532, 30.5781).. controls (-0.1532, 30.5781) and 
  (-0.1064, 30.4379) .. (-0.0082, 30.3866).. controls (-0.0082, 30.3866) and 
  (0.1156, 30.3077) .. (0.0757, 30.1868).. controls (0.0352, 30.0659) and (0.0, 
  30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.3822, 158.6264)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1942, 29.6333) .. (0.4572, 29.8079).. controls (0.4572, 29.8079) and 
  (0.2156, 29.7418) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.9904, 159.2274)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.3334, 30.0953) .. (0.3231, 30.3204).. controls (0.3231, 30.3204) and 
  (0.5376, 30.1371) .. (0.4646, 29.995).. controls (0.4646, 29.995) and (0.536, 
  30.1074) .. (0.4286, 30.2977).. controls (0.3352, 30.4636) and (0.2982, 
  30.5726) .. (0.2982, 30.5726).. controls (0.2982, 30.5726) and (0.3874, 
  30.1945) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.1856, 159.3348)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2974, 30.1725) .. (0.3511, 30.2982).. controls (0.3511, 30.2982) and 
  (0.2299, 30.1617) .. (0.1421, 30.149).. controls (0.1421, 30.149) and (0.4609,
   30.3342) .. (0.3815, 30.6204) -- (0.3381, 30.594).. controls (0.3381, 30.594)
   and (0.3649, 30.3434) .. (0.1926, 30.2191).. controls (0.0209, 30.0945) and 
  (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.3893, 159.0491)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0799, 30.0341) .. (0.163, 30.0214).. controls (0.2556, 30.0071) and 
  (0.3643, 30.0505) .. (0.3863, 30.2289).. controls (0.3987, 30.3276) and 
  (0.3987, 30.3556) .. (0.3987, 30.3556) -- (0.3342, 30.3424).. controls 
  (0.3342, 30.3424) and (0.3739, 30.168) .. (0.2638, 30.0915).. controls 
  (0.1537, 30.0151) and (0.0675, 30.0889) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.6029, 158.8126)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2424, 29.9196) .. (0.3741, 30.0855).. controls (0.5144, 30.2617) and 
  (0.5194, 30.2752) .. (0.5194, 30.2752) -- (0.4487, 30.2548).. controls 
  (0.4487, 30.2548) and (0.3691, 30.0839) .. (0.2596, 30.0386).. controls 
  (0.1505, 29.9934) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.092, 158.5021)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0828, 29.7545) .. (-0.3852, 29.7719).. controls (-0.3852, 29.7719) and 
  (-0.1352, 29.7936) .. (-0.0751, 29.9929) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2835, 158.3856)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (-0.055, 30.0315).. 
  controls (-0.055, 30.0315) and (-0.1894, 29.9394) .. (-0.399, 30.0569).. 
  controls (-0.399, 30.0569) and (-0.2397, 29.8883) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.3817, 158.3235)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (-0.0339, 30.045).. 
  controls (-0.0339, 30.045) and (-0.1564, 30.0016) .. (-0.2974, 30.023).. 
  controls (-0.2974, 30.023) and (-0.1535, 29.9251) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.4693, 158.2332)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0773, 29.9934) .. (-0.2172, 30.0355).. controls (-0.3477, 30.0746) and 
  (-0.512, 30.1635) .. (-0.6604, 30.3609).. controls (-0.6604, 30.3609) and 
  (-0.3889, 30.1106) .. (-0.1733, 30.0894).. controls (-0.1733, 30.0894) and 
  (-0.2691, 30.1135) .. (-0.5273, 30.2863).. controls (-0.5273, 30.2863) and 
  (-0.2029, 30.1143) .. (-0.0844, 30.1783) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-54.4083, 157.3561)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1135, 29.9497) .. (0.2016, 29.7518).. controls (0.29, 29.5542) and (0.5937,
   29.5346) .. (0.6316, 29.5875) -- (0.612, 29.6494).. controls (0.612, 29.6494)
   and (0.5051, 29.583) .. (0.3498, 29.6748).. controls (0.195, 29.7666) and 
  (0.2693, 29.9182) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.4603, 158.4941)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2807, 29.6936) .. (0.4831, 29.8471).. controls (0.6858, 30.0008) and 
  (0.7414, 30.2458) .. (0.7414, 30.2458).. controls (0.7414, 30.2458) and 
  (0.8149, 30.5575) .. (1.0218, 30.662).. controls (1.0218, 30.662) and (0.6858,
   30.5128) .. (0.648, 30.281).. controls (0.648, 30.281) and (0.5204, 29.7862) 
  .. (0.1426, 30.0103) -- (0.0881, 30.0362) -- (-0.0328, 30.0362) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.3128, 156.4105)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1336, 30.5929) .. (-0.1241, 30.997).. controls (-0.3077, 31.2848) and 
  (-0.3606, 31.4007) .. (-0.3606, 31.4007).. controls (-0.3606, 31.4007) and 
  (-0.3839, 31.3189) .. (-0.1881, 30.9538).. controls (0.0079, 30.589) and 
  (-0.0979, 30.1222) .. (-0.0979, 30.1222) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.4742, 156.0682)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0524, 30.2839) .. (-0.0344, 30.5429).. controls (-0.1214, 30.8014) and 
  (-0.1931, 30.826) .. (-0.2244, 30.9671).. controls (-0.2244, 30.9671) and 
  (-0.2019, 30.8369) .. (-0.1196, 30.6292).. controls (-0.0376, 30.4215) and 
  (-0.0582, 30.2241) .. (-0.0582, 30.2241).. controls (-0.0582, 30.2241) and 
  (0.0045, 30.1505) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.2139, 158.2163)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.0378, 30.0712).. 
  controls (0.0378, 30.0712) and (0.1826, 30.1199) .. (0.2574, 30.1828).. 
  controls (0.2574, 30.1828) and (0.1876, 30.0392) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.1371, 158.0357)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1961, 30.0942) .. (0.2606, 30.241).. controls (0.2606, 30.241) and (0.1807,
   30.1667) .. (0.1458, 30.1413) -- (0.213, 30.2241) -- (0.0392, 30.136) -- 
  (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.6582, 157.754)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (-0.0302, 
  29.9947) and (-0.0587, 29.9934) .. (-0.0894, 29.9979).. controls (-0.1707, 
  30.0114) and (-0.2429, 30.0579) .. (-0.3011, 30.1146) -- (-0.3604, 30.1804) --
   (-0.3993, 30.2339).. controls (-0.4326, 30.2723) and (-0.4874, 30.3127) .. 
  (-0.5413, 30.3098).. controls (-0.5413, 30.3098) and (-0.4247, 30.3162) .. 
  (-0.3408, 30.2495).. controls (-0.2569, 30.1831) and (-0.0757, 30.0347) .. 
  (-0.023, 30.0881) -- (0.0032, 30.0005) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6025, 155.7269)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.1797, 30.1889) .. (-0.1889, 30.4186).. controls (-0.1984, 30.6485) and 
  (-0.1701, 30.7575) .. (-0.1701, 30.7575).. controls (-0.1701, 30.7575) and 
  (-0.1656, 30.5125) .. (-0.1299, 30.4501) -- (-0.1299, 30.5562).. controls 
  (-0.1299, 30.5562) and (0.0304, 30.1992) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.3926, 156.0206)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.059) and
   (-0.0185, 30.1207) .. (-0.0209, 30.1802).. controls (-0.0265, 30.3096) and 
  (-0.0127, 30.4419) .. (0.0325, 30.5638).. controls (0.0609, 30.6398) and 
  (0.1064, 30.707) .. (0.1588, 30.7681).. controls (0.2072, 30.8252) and 
  (0.2638, 30.88) .. (0.2961, 30.9483).. controls (0.2961, 30.9483) and (0.2521,
   30.7519) .. (0.1257, 30.5995).. controls (-0.0008, 30.4469) and (0.0717, 
  30.2096) .. (0.0717, 30.2096).. controls (0.0717, 30.2096) and (0.0, 30.0807) 
  .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.2792, 156.7224)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2103, 30.0534) .. (0.3463, 30.0).. controls (0.3463, 30.0) and (0.1831, 
  30.0807) .. (-0.0534, 29.7399).. controls (-0.29, 29.3989) and (-0.6027, 
  29.4005) .. (-0.6027, 29.4005) -- (-0.5744, 29.5174).. controls (-0.5744, 
  29.5174) and (-0.1955, 29.5682) .. (-0.0818, 29.8749).. controls (0.0323, 
  30.1818) and (-0.2217, 30.4752) .. (-0.2217, 30.4752).. controls (-0.2217, 
  30.4752) and (0.0646, 30.276) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.9761, 157.2337)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.4175, 30.0781) .. (0.4506, 30.3524).. controls (0.4665, 30.4837) and 
  (0.4281, 30.6144) .. (0.3778, 30.734).. controls (0.3421, 30.8197) and (0.285,
   30.9036) .. (0.2635, 30.9943).. controls (0.2897, 30.8512) and (0.3511, 
  30.716) .. (0.3704, 30.5718).. controls (0.3889, 30.4326) and (0.3241, 30.344)
   .. (0.2053, 30.281).. controls (0.1453, 30.249) and (0.0783, 30.2244) .. 
  (0.0111, 30.2111).. controls (0.0111, 30.2111) and (0.0423, 30.0841) .. (-0.0,
   30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.8421, 156.8921)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.3167, 30.1289) .. (0.1492, 30.5286).. controls (0.1492, 30.5286) and 
  (0.1857, 30.087) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.7151, 157.5301)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.2789, 30.1281) .. (-0.3466, 30.2368).. controls (-0.4146, 30.3455) and 
  (-0.4146, 30.5376) .. (-0.4146, 30.5376).. controls (-0.4146, 30.5376) and 
  (-0.3503, 30.2511) .. (-0.2072, 30.1831).. controls (-0.064, 30.1154) and 
  (-0.0466, 30.108) .. (-0.0466, 30.108) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.1074, 156.6867)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0) -- (0.027, 30.0762).. 
  controls (0.0474, 30.1431) and (0.0619, 30.2119) .. (0.0706, 30.2813).. 
  controls (0.0976, 30.4924) and (0.0669, 30.7064) .. (-0.0299, 30.8972).. 
  controls (-0.0667, 30.9689) and (-0.0863, 31.0451) .. (-0.0804, 31.1266).. 
  controls (-0.0423, 30.9993) and (0.0053, 30.861) .. (0.105, 30.7678).. 
  controls (0.2312, 30.6498) and (0.5075, 30.082) .. (0.1347, 29.8629).. 
  controls (0.1347, 29.8629) and (0.295, 30.122) .. (0.2553, 30.3643).. controls
   (0.2156, 30.6067) and (0.0836, 30.7445) .. (0.0836, 30.7445).. controls 
  (0.0836, 30.7445) and (0.3641, 30.294) .. (0.0738, 29.8921) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.4905, 156.4711)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.1699, 30.1617) .. (-0.1098, 30.4072).. controls (-0.0495, 30.6525) and 
  (-0.0418, 30.7358) .. (-0.0654, 30.7935).. controls (-0.0654, 30.7935) and 
  (0.0, 30.7411) .. (-0.0315, 30.4331).. controls (-0.0315, 30.4331) and 
  (0.0225, 30.6072) .. (0.0087, 30.6874).. controls (0.0265, 30.5845) and 
  (0.0331, 30.48) .. (0.0193, 30.3752).. controls (0.0116, 30.3183) and (0.0267,
   30.2527) .. (0.064, 30.2074) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.7151, 156.7184)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.1699, 30.1818) .. (-0.1413, 30.3897).. controls (-0.1127, 30.5972) and 
  (0.0312, 30.7535) .. (0.0667, 30.8546).. controls (0.0667, 30.8546) and 
  (-0.1849, 30.2738) .. (0.0482, 30.1191).. controls (0.0482, 30.1191) and 
  (0.0069, 30.0418) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.0531, 157.7344)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.4741, 30.1868) .. (0.6072, 30.4006).. controls (0.7403, 30.6138) and 
  (0.8033, 30.7258) .. (0.8771, 30.753).. controls (0.8771, 30.753) and (0.7726,
   30.7604) .. (0.6324, 30.5879).. controls (0.4919, 30.4149) and (0.4008, 
  30.267) .. (0.2037, 30.2103) -- (0.0064, 30.1535) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-51.7489, 157.7483)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2559, 30.0751) .. (0.3315, 30.2339) -- (0.395, 30.3876).. controls (0.395, 
  30.3876) and (0.1812, 30.1487) .. (0.0646, 30.1191) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.5975, 157.2066)}]
      \path[fill=cf9e8b6,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1982, 30.0619) .. (0.1561, 30.236).. controls (0.1561, 30.236) and (0.1042,
   30.3445) .. (0.081, 30.3691).. controls (0.081, 30.3691) and (-0.0116, 
  30.8342) .. (-0.0974, 30.8739).. controls (-0.1834, 30.9131) and (-0.2275, 
  30.7305) .. (-0.2675, 30.7258).. controls (-0.3074, 30.7213) and (-0.4048, 
  30.8633) .. (-0.4532, 30.8427).. controls (-0.5017, 30.8218) and (-0.535, 
  30.8004) .. (-0.572, 30.604).. controls (-0.6093, 30.4072) and (-0.6162, 
  30.3654) .. (-0.6234, 30.3535).. controls (-0.6302, 30.3418) and (-0.8043, 
  30.1458) .. (-0.6657, 30.0437).. controls (-0.5273, 29.9415) and (-0.2611, 
  30.0818) .. (-0.2611, 30.0818) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2603, 155.7269)}]
      \path[fill=c5e85a9,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0241, 30.2148) .. (0.0479, 30.3262).. controls (0.1199, 30.4376) and 
  (0.2056, 30.5522) .. (0.2114, 30.6144) -- (0.2223, 30.5675).. controls 
  (0.2223, 30.5675) and (0.3043, 30.1376) .. (0.4048, 30.0418).. controls 
  (0.4048, 30.0418) and (0.2768, 30.1746) .. (0.2627, 30.2686).. controls 
  (0.2627, 30.2686) and (0.0037, 30.1349) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6686, 157.068)}]
      \path[fill=black,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.5887, 29.7399) .. (1.1308, 29.9466).. controls (1.1308, 29.9466) and 
  (0.7178, 29.7952) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6157, 156.9943)}]
      \path[fill=black,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.6014, 29.9278) .. (1.0234, 30.2257).. controls (1.0234, 30.2257) and 
  (0.6025, 29.9844) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6547, 156.9119)}]
      \path[fill=black,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.5326, 30.1336) .. (0.7699, 30.481).. controls (0.7699, 30.481) and (0.5315,
   30.2064) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2004, 157.1061)}]
      \path[fill=black,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.4413, 29.6965) .. (-0.9594, 29.7897).. controls (-0.9594, 29.7897) and 
  (-0.5416, 29.727) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.258, 157.0607)}]
      \path[fill=black,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.2836, 29.8463) .. (-0.7951, 30.0521).. controls (-0.7951, 30.0521) and 
  (-0.3998, 29.9148) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2004, 157.0012)}]
      \path[fill=black,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.5038, 30.1098) .. (-0.6935, 30.426).. controls (-0.6935, 30.426) and 
  (-0.4522, 30.136) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.3109, 156.8074)}]
      \path[fill=c231f20,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.2074, 29.8291) .. (0.3334, 29.878).. controls (0.4593, 29.9267) and 
  (0.6075, 30.0527) .. (0.6075, 30.0527).. controls (0.6075, 30.0527) and 
  (0.6207, 30.2543) .. (0.4773, 30.5101).. controls (0.4773, 30.5101) and 
  (0.4609, 30.5506) .. (0.3649, 30.489).. controls (0.2688, 30.4268) and 
  (0.2736, 30.4416) .. (0.1791, 30.4858).. controls (0.0847, 30.5294) and 
  (0.0717, 30.3829) .. (0.0717, 30.3829).. controls (0.0717, 30.3829) and 
  (0.0312, 30.2537) .. (0.0222, 30.1064).. controls (0.0222, 30.1064) and 
  (-0.0082, 30.0407) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2517, 156.7932)}]
      \path[fill=white,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0333, 29.941) .. (0.0926, 29.932).. controls (0.0926, 29.932) and (0.0759, 
  30.0492) .. (0.0926, 30.0892).. controls (0.0926, 30.0892) and (0.0733, 
  30.1193) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6422, 156.7611)}]
      \path[fill=white,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0394, 30.0733) .. (-0.105, 30.0733).. controls (-0.105, 30.0733) and 
  (-0.0677, 30.0016) .. (-0.0677, 29.9526).. controls (-0.0677, 29.9526) and 
  (-0.0542, 29.9373) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.1065, 156.4496)}]
      \path[fill=white,even odd rule] (0.0, 30.0) -- (0.009, 30.0667) -- 
  (0.0333, 30.1373) -- (-0.0135, 30.1651) -- (-0.0431, 30.1627) -- (-0.0357, 
  30.0976) -- (-0.0188, 30.0468) -- (-0.0093, 30.0217) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.8251, 156.2386)}]
      \path[fill=white,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0863, 30.0569) .. (0.0746, 30.0).. controls (0.063, 29.9426) and (0.031, 
  29.8622) .. (0.031, 29.8622) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.0334, 156.309)}]
      \path[fill=cb21f2f,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0884, 29.9698) .. (0.1344, 30.0169).. controls (0.1344, 30.0169) and 
  (0.1603, 29.941) .. (0.1595, 29.9074).. controls (0.1585, 29.8743) and 
  (0.1945, 29.8698) .. (0.2098, 29.8915) -- (0.2334, 29.9328).. controls 
  (0.2334, 29.9328) and (0.2363, 29.7923) .. (0.1667, 29.7598).. controls 
  (0.0974, 29.7275) and (0.0812, 29.7751) .. (0.0812, 29.7751).. controls 
  (0.0812, 29.7751) and (0.0, 29.7182) .. (-0.0505, 29.8455).. controls 
  (-0.0505, 29.8455) and (-0.0376, 29.859) .. (-0.0251, 29.9275).. controls 
  (-0.0127, 29.9958) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.0662, 157.6881)}]
      \path[fill=cba7f2c,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1029, 30.0191) .. (0.1397, 29.9249).. controls (0.1397, 29.9249) and 
  (0.1548, 30.04) .. (0.0082, 30.0839) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6392, 157.7007)}]
      \path[fill=cba7f2c,even odd rule] (0.0, 30.0) -- (-0.0545, 30.1318).. 
  controls (-0.0545, 30.1318) and (-0.1894, 30.0701) .. (-0.1934, 30.0243).. 
  controls (-0.1974, 29.9788) and (-0.173, 29.9291) .. (-0.173, 29.9291).. 
  controls (-0.173, 29.9291) and (-0.1117, 30.0918) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.4296, 157.7712)}]
      \path[fill=c231f20,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0929, 29.9473) .. (0.1384, 29.9563).. controls (0.1839, 29.9653) and 
  (0.2979, 30.027) .. (0.326, 30.0836) -- (0.3024, 30.1323) -- (0.3119, 
  30.1812).. controls (0.309, 30.1934) and (0.1677, 30.3818) .. (0.1802, 
  30.4522).. controls (0.1924, 30.5226) and (0.2384, 30.4382) .. (0.3037, 
  30.49).. controls (0.3691, 30.5416) and (0.359, 30.5689) .. (0.3836, 
  30.5773).. controls (0.4083, 30.5853) and (0.4299, 30.5929) .. (0.4559, 
  30.5535).. controls (0.4815, 30.5141) and (0.5239, 30.4815) .. (0.5538, 
  30.494).. controls (0.5839, 30.5061) and (0.6503, 30.5104) .. (0.6287, 
  30.418).. controls (0.607, 30.3254) and (0.5797, 30.2588) .. (0.5784, 
  30.1826).. controls (0.5771, 30.1064) and (0.6244, 30.0701) .. (0.6421, 
  30.0616).. controls (0.6599, 30.0537) and (0.7781, 29.9878) .. (0.812, 
  29.9915).. controls (0.8461, 29.995) and (0.9567, 30.0646) .. (0.9567, 
  30.0646) -- (0.9221, 30.0836).. controls (0.9221, 30.0836) and (0.8734, 
  30.0508) .. (0.8475, 30.0712).. controls (0.8475, 30.0712) and (0.8271, 
  30.1529) .. (0.7715, 30.1664).. controls (0.7157, 30.1799) and (0.6818, 
  30.1767) .. (0.6408, 30.1392).. controls (0.6408, 30.1392) and (0.6056, 
  30.1812) .. (0.6247, 30.2521).. controls (0.6437, 30.3231) and (0.6792, 
  30.4479) .. (0.6697, 30.4752).. controls (0.6604, 30.5022) and (0.6165, 
  30.5199) .. (0.5728, 30.5239).. controls (0.5294, 30.5281) and (0.4826, 
  30.5564) .. (0.4686, 30.5715).. controls (0.4546, 30.5866) and (0.3871, 
  30.6429) .. (0.3122, 30.5392) -- (0.2265, 30.5265).. controls (0.2122, 
  30.5215) and (0.131, 30.4752) .. (0.1426, 30.4183).. controls (0.1543, 
  30.3614) and (0.2725, 30.1752) .. (0.2725, 30.1752) -- (0.276, 30.1148) -- 
  (0.2834, 30.0915).. controls (0.2834, 30.0915) and (0.241, 30.149) .. (0.1807,
   30.1429).. controls (0.1204, 30.1365) and (0.077, 30.0754) .. (0.0849, 
  30.0005) -- (0.0445, 30.0175) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2772, 157.7698)}]
      \path[fill=ce0bd2d,even odd rule] (0.0, 30.0) -- (0.0397, 30.0138).. 
  controls (0.0397, 30.0138) and (0.0135, 30.0561) .. (0.0505, 30.0788).. 
  controls (0.0876, 30.1013) and (0.0987, 30.0487) .. (0.0987, 30.0487) -- 
  (0.1275, 30.0751).. controls (0.1275, 30.0751) and (0.0942, 30.1326) .. 
  (0.0352, 30.1066).. controls (-0.0233, 30.081) and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6025, 157.6432)}]
      \path[fill=ce0bd2d,even odd rule] (0.0, 30.0) -- (0.022, 29.9812).. 
  controls (0.022, 29.9812) and (0.0564, 30.0209) .. (0.0812, 30.0122).. 
  controls (0.1058, 30.0034) and (0.1122, 29.9712) .. (0.1058, 29.9476) -- 
  (0.1429, 29.9476).. controls (0.1429, 29.9476) and (0.1527, 30.0008) .. 
  (0.114, 30.0262).. controls (0.0751, 30.0513) and (0.0214, 30.0468) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.1862, 157.2638)}]
      \path[fill=cb96367,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.3334, 29.9733) .. (0.4252, 30.0511) -- (0.4371, 30.0561).. controls 
  (0.4371, 30.0561) and (0.4352, 30.1124) .. (0.3638, 30.09).. controls (0.3019,
   30.0701) and (0.2738, 30.1482) .. (0.2548, 30.1625).. controls (0.2357, 
  30.1773) and (0.1955, 30.1998) .. (0.168, 30.1566).. controls (0.1405, 
  30.1135) and (0.104, 30.0675) .. (0.0749, 30.0675).. controls (0.046, 30.0677)
   and (0.0143, 30.0751) .. (0.0143, 30.0751).. controls (0.0143, 30.0751) and 
  (-0.0222, 30.0796) .. (-0.0151, 30.028) -- (-0.0077, 29.9971) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2772, 157.7698)}]
      \path[fill=white,even odd rule] (0.0, 30.0) -- (0.0397, 30.0138) -- 
  (0.031, 30.0487) -- (-0.0048, 30.0487) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.6025, 157.6432)}]
      \path[fill=white,even odd rule] (0.0, 30.0) -- (0.022, 29.9812) -- 
  (0.0542, 30.0074) -- (0.0302, 30.0328) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.04, 157.5446)}]
      \path[fill=cba7f2c,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0384, 29.9587) .. (0.0865, 30.0).. controls (0.0865, 30.0) and (0.0328, 
  30.0037) .. (-0.0323, 30.0511) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.4105, 158.0334)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1254, 29.7441) .. (0.2765, 29.8463).. controls (0.2765, 29.8463) and 
  (0.0839, 29.8667) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.2276, 157.8171)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.118, 30.045) .. (0.1543, 30.105) -- (0.2365, 30.0754) -- (0.1453, 
  30.0656).. controls (0.1453, 30.0656) and (0.068, 29.991) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.294, 158.4687)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (-0.0931, 29.9473) -- 
  (0.0175, 29.9579).. controls (0.0175, 29.9579) and (-0.1617, 29.7828) .. 
  (-0.3495, 29.9458).. controls (-0.3495, 29.9458) and (-0.1752, 29.9384) .. 
  (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.3068, 158.4366)}]
      \path[fill=c5e85a9,nonzero rule] (0.0, 30.0) -- (0.131, 30.0421).. 
  controls (0.131, 30.0421) and (0.2818, 29.9616) .. (0.3638, 30.0103).. 
  controls (0.3638, 30.0103) and (0.2715, 29.8553) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.8017, 155.6499)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0648, 30.4929) .. (0.2712, 30.722).. controls (0.2712, 30.722) and (0.0826,
   30.2707) .. (0.1003, 30.1601) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-46.5177, 158.0926)}]
      \path[fill=cefc283,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.6448, 30.1672) .. (0.5659, 30.7093).. controls (0.5659, 30.7093) and 
  (0.7943, 30.0717) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.1924, 158.0672)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0572, 30.0466) .. (0.1109, 30.0064).. controls (0.1109, 30.0064) and 
  (0.1498, 29.8391) .. (-0.0397, 29.8233).. controls (-0.0397, 29.8233) and 
  (0.0489, 29.9344) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.155, 158.0767)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (0.0333, 30.0082) -- 
  (0.0609, 30.0011).. controls (0.063, 29.9828) and (0.0654, 29.9389) .. (0.04, 
  29.9045).. controls (0.0259, 29.8849) and (0.0048, 29.8711) .. (-0.0228, 
  29.8624).. controls (-0.0021, 29.8997) and (0.0183, 29.954) .. (0.0, 
  30.0)(0.0333, 30.0527).. controls (-0.0093, 30.0527) and (-0.0423, 30.0262) ..
   (-0.0439, 30.0251) -- (-0.0606, 30.0116) -- (-0.0476, 29.9942).. controls 
  (-0.0101, 29.9442) and (-0.0863, 29.846) .. (-0.087, 29.845) -- (-0.1196, 
  29.8047) -- (-0.0677, 29.8087).. controls (-0.0016, 29.8145) and (0.0468, 
  29.8381) .. (0.0762, 29.8786).. controls (0.1207, 29.9394) and (0.1037, 
  30.0159) .. (0.1029, 30.0193) -- (0.1011, 30.0275) -- (0.0945, 30.032) -- 
  (0.0333, 30.0527);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.4861, 158.0887)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0572, 30.0164) .. (0.0937, 29.9733).. controls (0.0937, 29.9733) and 
  (0.1117, 29.8905) .. (-0.0593, 29.8516).. controls (-0.0593, 29.8516) and 
  (0.0064, 29.9272) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.458, 158.1131)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (0.0497, 29.9828).. controls
   (0.0489, 29.9648) and (0.0315, 29.9344) .. (-0.0283, 29.91).. controls 
  (-0.0148, 29.9354) and (-0.0019, 29.9672) .. (0.0, 30.0)(0.0029, 30.0447) -- 
  (-0.0286, 30.0407) -- (-0.046, 30.0357) -- (-0.0445, 30.0175).. controls 
  (-0.04, 29.9653) and (-0.082, 29.9045) .. (-0.0984, 29.8852) -- (-0.1431, 
  29.8338) -- (-0.0767, 29.8492).. controls (0.1135, 29.8926) and (0.0939, 
  29.9931) .. (0.0931, 29.9971) -- (0.0921, 30.0029) -- (0.0884, 30.0069).. 
  controls (0.0619, 30.0381) and (0.0273, 30.0447) .. (0.0029, 30.0447);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.8483, 157.8423)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0937, 29.9929) .. (0.0884, 29.9204).. controls (0.0884, 29.9204) and 
  (-0.0196, 29.7973) .. (-0.096, 29.8698).. controls (-0.096, 29.8698) and 
  (-0.0103, 29.9235) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.919, 158.003)}]
      \path[fill=black,nonzero rule] (0.0, 30.0).. controls (0.0249, 30.0209) 
  and (0.0598, 30.0572) .. (0.0736, 30.1029).. controls (0.0931, 30.0976) and 
  (0.1207, 30.0855) .. (0.1228, 30.0577).. controls (0.0995, 30.0339) and 
  (0.0418, 29.9873) .. (0.0, 30.0)(0.0373, 30.1524) -- (0.0344, 30.1315).. 
  controls (0.0273, 30.0773) and (-0.0299, 30.0304) .. (-0.0511, 30.0172) -- 
  (-0.0757, 30.0019) -- (-0.0545, 29.982).. controls (-0.0344, 29.9627) and 
  (-0.0106, 29.9532) .. (0.0161, 29.9532).. controls (0.0897, 29.9532) and 
  (0.1588, 30.0307) .. (0.1617, 30.0341) -- (0.1664, 30.0394) -- (0.167, 
  30.0474).. controls (0.1725, 30.1217) and (0.0984, 30.1476) .. (0.0582, 
  30.1505) -- (0.0373, 30.1524);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-55.8588, 157.5377)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (-0.0066, 30.0561) .. (-0.0561, 30.1).. controls (-0.0561, 30.1) and (-0.1738,
   30.0558) .. (-0.1498, 29.919).. controls (-0.1498, 29.919) and (-0.0656, 
  30.0095) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-56.0219, 157.578)}]
      \path[fill=black,nonzero rule] (0.0, 30.0).. controls (0.0053, 30.0624) 
  and (0.0479, 30.0939) .. (0.0696, 30.1056) -- (0.1016, 30.0537).. controls 
  (0.0638, 30.0471) and (0.0265, 30.0217) .. (0.0, 30.0)(0.0788, 30.1582) -- 
  (0.0664, 30.1535).. controls (0.0196, 30.136) and (-0.063, 30.0704) .. 
  (-0.0415, 29.9476) -- (-0.0339, 29.9037) -- (-0.0032, 29.9365).. controls 
  (0.0159, 29.9571) and (0.0759, 30.0108) .. (0.1201, 30.0108) -- (0.127, 
  30.0103) -- (0.1556, 30.0058) -- (0.1524, 30.0349).. controls (0.1521, 
  30.0376) and (0.1442, 30.0997) .. (0.0889, 30.1492) -- (0.0788, 30.1582);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.9251, 152.6406)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1461, 29.9182) .. (0.1251, 30.0884).. controls (0.1251, 30.0884) and 
  (0.0095, 30.1299) .. (-0.0114, 30.1897).. controls (-0.0114, 30.1897) and 
  (-0.0606, 30.1355) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.9036, 152.6197)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0254, 30.0593)
   and (-0.0273, 30.1) .. (-0.0233, 30.1254).. controls (0.0101, 30.0905) and 
  (0.0619, 30.0664) .. (0.087, 30.0561).. controls (0.0892, 30.027) and (0.0855,
   30.0056) .. (0.0762, 29.9952) -- (0.0513, 29.986) -- (0.0, 30.0)(-0.0198, 
  30.2154) -- (-0.045, 30.1879).. controls (-0.0508, 30.181) and (-0.1021, 
  30.1188) .. (-0.0376, 29.9743) -- (-0.0344, 29.9677) -- (-0.028, 29.964).. 
  controls (-0.0265, 29.9632) and (0.0124, 29.9415) .. (0.0513, 29.9415).. 
  controls (0.0754, 29.9415) and (0.0955, 29.9497) .. (0.1095, 29.9659).. 
  controls (0.1294, 29.9884) and (0.1363, 30.0241) .. (0.1299, 30.0743) -- 
  (0.1283, 30.0881) -- (0.1154, 30.0929).. controls (0.0746, 30.1074) and 
  (0.0053, 30.1445) .. (-0.0074, 30.1804) -- (-0.0198, 30.2154);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.5957, 152.3799)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0071, 29.8733) .. (-0.1117, 29.9071).. controls (-0.1117, 29.9071) and 
  (-0.1865, 29.9847) .. (-0.1244, 30.0955).. controls (-0.1244, 30.0955) and 
  (-0.0857, 29.9963) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.72, 152.4712)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0106, 30.0135)
   and (-0.0392, 30.0569) .. (-0.0222, 30.1183).. controls (-0.0026, 30.091) and
   (0.0294, 30.059) .. (0.0759, 30.0521) -- (0.0587, 30.0095).. controls 
  (0.0463, 29.9963) and (0.0267, 29.9937) .. (0.0, 30.0)(-0.0214, 30.2207) -- 
  (-0.0445, 30.1797).. controls (-0.1, 30.0804) and (-0.0582, 29.9958) .. 
  (-0.0283, 29.9648) -- (-0.0243, 29.9606) -- (-0.0185, 29.959).. controls 
  (0.028, 29.9455) and (0.0664, 29.9526) .. (0.091, 29.9791).. controls (0.1241,
   30.014) and (0.122, 30.0683) .. (0.1217, 30.0743) -- (0.1204, 30.096) -- 
  (0.0984, 30.0953).. controls (0.0283, 30.0953) and (-0.004, 30.1759) .. 
  (-0.0042, 30.1767) -- (-0.0214, 30.2207);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.3258, 152.331)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0071, 29.8733) .. (-0.1117, 29.9071).. controls (-0.1117, 29.9071) and 
  (-0.1865, 29.9847) .. (-0.1244, 30.0955).. controls (-0.1244, 30.0955) and 
  (-0.0855, 29.9963) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.4498, 152.4223)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0106, 30.0132)
   and (-0.0392, 30.0569) .. (-0.0222, 30.118).. controls (-0.0026, 30.0908) and
   (0.0294, 30.059) .. (0.0759, 30.0519) -- (0.0587, 30.0093).. controls 
  (0.0463, 29.9963) and (0.0267, 29.9934) .. (0.0, 30.0)(-0.0214, 30.2204) -- 
  (-0.0445, 30.1794).. controls (-0.1, 30.0802) and (-0.0582, 29.9955) .. 
  (-0.0283, 29.9648) -- (-0.0243, 29.9603) -- (-0.0185, 29.9587).. controls 
  (0.028, 29.9452) and (0.0661, 29.9524) .. (0.091, 29.9788).. controls (0.1241,
   30.0138) and (0.122, 30.0683) .. (0.1214, 30.0741) -- (0.1204, 30.096) -- 
  (0.0984, 30.095) -- (0.0982, 30.095).. controls (0.0283, 30.095) and (-0.004, 
  30.1757) .. (-0.0042, 30.1765) -- (-0.0214, 30.2204);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.1981, 152.409)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0802, 29.9442) .. (0.1416, 30.0352).. controls (0.1416, 30.0352) and 
  (0.0524, 30.0942) .. (0.0315, 30.1685).. controls (0.0315, 30.1685) and 
  (-0.0378, 30.1595) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.1737, 152.3912)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0143, 30.0646)
   and (-0.0082, 30.0979) .. (-0.0008, 30.1148) -- (0.0016, 30.1193).. controls 
  (0.0246, 30.0728) and (0.0659, 30.0357) .. (0.0902, 30.0164) -- (0.0368, 
  29.9907) -- (0.0, 30.0)(0.028, 30.1786) -- (0.009, 30.1762).. controls 
  (0.0064, 30.1757) and (-0.0161, 30.1722) .. (-0.0333, 30.1474).. controls 
  (-0.0569, 30.1132) and (-0.0595, 30.0572) .. (-0.0413, 29.9804) -- (-0.0392, 
  29.972) -- (-0.0323, 29.9672).. controls (-0.0294, 29.9651) and (-0.0011, 
  29.9463) .. (0.0368, 29.9463).. controls (0.0651, 29.9463) and (0.1058, 
  29.9571) .. (0.1402, 30.0082) -- (0.1527, 30.0267) -- (0.1341, 30.0392).. 
  controls (0.1334, 30.0397) and (0.0516, 30.095) .. (0.0333, 30.1601) -- 
  (0.028, 30.1786);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.3351, 152.5827)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1535, 30.0106) .. (0.077, 30.1029).. controls (0.077, 30.1029) and 
  (-0.0336, 30.109) .. (-0.0669, 30.1738).. controls (-0.0669, 30.1738) and 
  (-0.1143, 30.1148) .. (-0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.3248, 152.5532)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0423, 30.0445)
   and (-0.0572, 30.0781) .. (-0.0611, 30.1008).. controls (-0.0212, 30.0699) 
  and (0.0341, 30.0606) .. (0.0569, 30.0579) -- (0.0667, 30.0286).. controls 
  (0.0603, 30.0135) and (0.0265, 30.0032) .. (0.0, 30.0)(-0.0714, 30.1913) -- 
  (-0.0929, 30.1643).. controls (-0.0953, 30.1611) and (-0.1511, 30.0886) .. 
  (-0.0241, 29.9608) -- (-0.0169, 29.9534) -- (-0.0069, 29.9542).. controls 
  (0.0087, 29.9553) and (0.0873, 29.9632) .. (0.1077, 30.0108).. controls 
  (0.1183, 30.0355) and (0.1109, 30.0632) .. (0.0857, 30.0937) -- (0.0796, 
  30.1011) -- (0.0699, 30.1016).. controls (0.0426, 30.1032) and (-0.0331, 
  30.1167) .. (-0.0556, 30.1609) -- (-0.0714, 30.1913);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.1492, 152.5003)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.0995, 29.9907) .. (0.1069, 30.081).. controls (0.1069, 30.081) and 
  (-0.0074, 30.1196) .. (-0.0251, 30.1701).. controls (-0.0251, 30.1701) and 
  (-0.0651, 30.1228) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-48.132, 152.4725)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0222, 30.045) 
  and (-0.0283, 30.0773) .. (-0.0286, 30.0987).. controls (0.0013, 30.0728) and 
  (0.0439, 30.0537) .. (0.068, 30.0442).. controls (0.0574, 30.009) and (0.0238,
   30.0011) .. (0.0, 30.0)(-0.031, 30.1918) -- (-0.0558, 30.1619).. controls 
  (-0.0609, 30.1561) and (-0.1035, 30.0997) .. (-0.0333, 29.9675) -- (-0.0278, 
  29.9569) -- (-0.0159, 29.9558) -- (-0.0058, 29.9556).. controls (0.0487, 
  29.9556) and (0.1093, 29.982) .. (0.1154, 30.0569) -- (0.1167, 30.0741) -- 
  (0.1003, 30.0799).. controls (0.0572, 30.0945) and (-0.0082, 30.1275) .. 
  (-0.018, 30.155) -- (-0.031, 30.1918);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.878, 152.4348)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.109, 29.9423) .. (0.1172, 30.0693).. controls (0.1172, 30.0693) and (0.023,
   30.0788) .. (-0.0167, 30.1635).. controls (-0.0167, 30.1635) and (-0.0714, 
  30.1606) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.8568, 152.4137)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.022, 30.0511) 
  and (-0.0294, 30.0823) .. (-0.0312, 30.1008).. controls (0.0029, 30.059) and 
  (0.0487, 30.0413) .. (0.0757, 30.0347).. controls (0.0675, 29.9926) and 
  (0.0442, 29.9926) .. (0.0344, 29.9926) -- (0.0, 30.0)(-0.0201, 30.1701) -- 
  (-0.0349, 30.1691) -- (-0.0667, 30.1484).. controls (-0.0855, 30.1175) and 
  (-0.0759, 30.0609) .. (-0.0376, 29.9741) -- (-0.0344, 29.9672) -- (-0.0275, 
  29.9638).. controls (-0.0243, 29.9622) and (0.0029, 29.9481) .. (0.0344, 
  29.9481).. controls (0.059, 29.9481) and (0.1164, 29.9582) .. (0.1225, 
  30.0511) -- (0.1241, 30.0725) -- (0.1027, 30.0743).. controls (0.0992, 
  30.0749) and (0.0201, 30.0841) .. (-0.0138, 30.1561) -- (-0.0201, 30.1701);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5645, 152.4163)}]
      \path[fill=c85b3da,even odd rule] (0.0, 30.0).. controls (0.0, 30.0) and 
  (0.1212, 29.9225) .. (0.1347, 30.0407).. controls (0.1347, 30.0407) and 
  (0.0595, 30.0743) .. (0.0434, 30.1487).. controls (0.0434, 30.1487) and 
  (-0.0193, 30.1437) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-47.5384, 152.3988)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (-0.0061, 30.0548)
   and (0.0016, 30.0847) .. (0.0111, 30.0997).. controls (0.0307, 30.055) and 
  (0.068, 30.0275) .. (0.0892, 30.0151).. controls (0.0815, 29.9833) and 
  (0.0635, 29.9833) .. (0.0545, 29.9833) -- (0.0, 30.0)(0.0405, 30.1588) -- 
  (0.0209, 30.1572) -- (-0.0209, 30.132).. controls (-0.0447, 30.1024) and 
  (-0.0521, 30.0521) .. (-0.0429, 29.9833) -- (-0.0415, 29.9733) -- (-0.0328, 
  29.9675).. controls (-0.0283, 29.9643) and (0.013, 29.9391) .. (0.0545, 
  29.9391).. controls (0.0812, 29.9391) and (0.1275, 29.9503) .. (0.136, 
  30.0243) -- (0.1378, 30.0405) -- (0.123, 30.0471).. controls (0.1225, 30.0476)
   and (0.0577, 30.0775) .. (0.0445, 30.1394) -- (0.0405, 30.1588);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.1113, 158.2256)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0).. controls (0.0783, 30.0381) 
  and (0.1527, 30.0849) .. (0.2223, 30.1386) -- (0.2733, 30.1812) -- (0.2977, 
  30.204) -- (0.3212, 30.2281) -- (0.3437, 30.254) -- (0.3643, 30.2815) -- 
  (0.3831, 30.3122) -- (0.3979, 30.3463) -- (0.4337, 30.4286) -- (0.3535, 
  30.3799).. controls (0.3088, 30.3532) and (0.2622, 30.3262) .. (0.2156, 
  30.3035) -- (0.145, 30.2725) -- (0.1109, 30.2622) -- (0.0955, 30.2598) -- 
  (0.0855, 30.2601) -- (0.0971, 30.2082).. controls (0.1315, 30.2402) and 
  (0.1632, 30.2731) .. (0.1947, 30.3072).. controls (0.2262, 30.3418) and 
  (0.2553, 30.3776) .. (0.2836, 30.4143) -- (0.3231, 30.472) -- (0.341, 30.5019)
   -- (0.3577, 30.5331) -- (0.3723, 30.5652) -- (0.3834, 30.5988) -- (0.3903, 
  30.6331) -- (0.3897, 30.6678) -- (0.3826, 30.6345) -- (0.3702, 30.6033) -- 
  (0.354, 30.5741) -- (0.3358, 30.5458).. controls (0.3093, 30.5096) and 
  (0.2813, 30.4747) .. (0.2503, 30.4416).. controls (0.2204, 30.4085) and 
  (0.1884, 30.3765) .. (0.1561, 30.345).. controls (0.1241, 30.3133) and 
  (0.0902, 30.2828) .. (0.0569, 30.2537) -- (0.009, 30.2119) -- (0.0685, 
  30.2019) -- (0.0982, 30.1992) -- (0.1228, 30.2024) -- (0.1659, 30.214).. 
  controls (0.1931, 30.2238) and (0.2185, 30.2352) .. (0.2432, 30.2471).. 
  controls (0.2924, 30.2725) and (0.3395, 30.2998) .. (0.3858, 30.3299) -- 
  (0.341, 30.3638) -- (0.3313, 30.3379) -- (0.3172, 30.3122) -- (0.3003, 
  30.2871) -- (0.2815, 30.2625).. controls (0.2556, 30.2302) and (0.2262, 
  30.1992) .. (0.1955, 30.1699).. controls (0.1339, 30.1103) and (0.0677, 
  30.0548) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-52.5658, 152.716)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0638, 29.9804).. 
  controls (0.1566, 29.2692) and (0.5771, 28.6943) .. (0.5813, 28.6887) -- 
  (0.635, 28.7281).. controls (0.6308, 28.734) and (0.2172, 29.3002) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-49.3961, 157.449)}]
      \path[fill=c231f20,nonzero rule] (0.0, 30.0) -- (-0.0122, 29.9436) -- 
  (1.8455, 29.5409) -- (1.8576, 29.5973) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-53.251, 152.3512)}]
      \path[fill=black,nonzero rule] (0.0, 30.0) -- (-0.0042, 29.982) -- 
  (0.0005, 29.9328) -- (0.0333, 29.8698) -- (0.0609, 29.8407) -- (0.0931, 
  29.8161) -- (0.1614, 29.7815) -- (0.2225, 29.7582).. controls (0.259, 29.7457)
   and (0.2855, 29.742) .. (0.2855, 29.742).. controls (0.2855, 29.742) and 
  (0.2675, 29.7619) .. (0.2368, 29.7849) -- (0.1831, 29.8225) -- (0.122, 
  29.8603) -- (0.0677, 29.9013) -- (0.028, 29.9452).. controls (0.0074, 29.9741)
   and (0.0, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-40.8335, 162.15)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.8665, 28.6575) -- 
  (-0.8665, 30.0) -- (-1.2935, 30.0) -- (-1.2935, 27.8127) -- (-0.9125, 27.8127)
   -- (-0.046, 29.1523) -- (-0.046, 27.8127) -- (0.381, 27.8127) -- (0.381, 
  30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-38.8015, 164.0778)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.2768, 30.7959) -- 
  (0.2672, 30.7959) -- cycle(0.5099, 31.5425) -- (0.3807, 31.1552) -- (-0.3966, 
  31.1552) -- (-0.5286, 31.5425) -- (-0.9742, 31.5425) -- (-0.1783, 29.3549) -- 
  (0.1564, 29.3549) -- (0.9551, 31.5425) -- (0.5099, 31.5425);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-35.6523, 162.15)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.8665, 28.6575) -- 
  (-0.8665, 30.0) -- (-1.2935, 30.0) -- (-1.2935, 27.8127) -- (-0.9125, 27.8127)
   -- (-0.046, 29.1523) -- (-0.046, 27.8127) -- (0.381, 27.8127) -- (0.381, 
  30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-33.4936, 163.2712)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 30.8972) -- 
  (-0.4241, 30.8972) -- (-0.4241, 30.0) -- (-1.0816, 28.7096) -- (-0.6175, 
  28.7096) -- (-0.209, 29.5915) -- (0.1934, 28.7096) -- (0.6575, 28.7096) -- 
  (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-31.5774, 164.0778)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.2765, 30.7959) -- 
  (0.2675, 30.7959) -- cycle(0.5101, 31.5425) -- (0.381, 31.1552) -- (-0.3963, 
  31.1552) -- (-0.5284, 31.5425) -- (-0.9739, 31.5425) -- (-0.1781, 29.3549) -- 
  (0.1569, 29.3549) -- (0.9557, 31.5425) -- (0.5101, 31.5425);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-28.4278, 162.15)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.8665, 28.6575) -- 
  (-0.8665, 30.0) -- (-1.2935, 30.0) -- (-1.2935, 27.8127) -- (-0.9125, 27.8127)
   -- (-0.046, 29.1523) -- (-0.046, 27.8127) -- (0.381, 27.8127) -- (0.381, 
  30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-25.6279, 162.4377)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.1752, 30.1812)
   and (-0.3842, 30.2487) .. (-0.6175, 30.2487).. controls (-0.8573, 30.2487) 
  and (-1.0538, 30.1627) .. (-1.2073, 30.009).. controls (-1.4288, 29.7878) and 
  (-1.4227, 29.5142) .. (-1.4227, 29.1364).. controls (-1.4227, 28.7588) and 
  (-1.4288, 28.485) .. (-1.2073, 28.2638).. controls (-1.0538, 28.1101) and 
  (-0.8633, 28.0244) .. (-0.6175, 28.0244).. controls (-0.1106, 28.0244) and 
  (0.1474, 28.3561) .. (0.2058, 28.725) -- (-0.2241, 28.725).. controls 
  (-0.2736, 28.5189) and (-0.3995, 28.4054) .. (-0.6175, 28.4054).. controls 
  (-0.7342, 28.4054) and (-0.8297, 28.4511) .. (-0.8909, 28.522).. controls 
  (-0.9739, 28.6141) and (-0.9956, 28.7157) .. (-0.9956, 29.1364).. controls 
  (-0.9956, 29.5574) and (-0.9739, 29.6621) .. (-0.8909, 29.7539).. controls 
  (-0.8297, 29.8248) and (-0.7342, 29.8677) .. (-0.6175, 29.8677).. controls 
  (-0.4887, 29.8677) and (-0.3842, 29.8217) .. (-0.3133, 29.7447).. controls 
  (-0.2426, 29.6648) and (-0.2151, 29.5666) .. (-0.2151, 29.4531) -- (-0.2151, 
  29.37) -- (-0.6175, 29.37) -- (-0.6175, 29.0134) -- (0.209, 29.0134) -- 
  (0.209, 29.333).. controls (0.209, 29.6497) and (0.1537, 29.8399) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-41.406, 160.7887)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 31.8066) -- (-0.427,
   31.8066) -- (-0.427, 30.0) -- (-0.9983, 30.0) -- (-0.9983, 29.6193) -- 
  (0.5715, 29.6193) -- (0.5715, 30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-40.2574, 158.5302)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 27.8124) -- (1.4409,
   27.8124) -- (1.4409, 28.1934) -- (0.427, 28.1934) -- (0.427, 28.7065) -- 
  (1.2904, 28.7065) -- (1.2904, 29.0875) -- (0.427, 29.0875) -- (0.427, 29.6187)
   -- (1.4409, 29.6187) -- (1.4409, 30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-37.0195, 158.5074)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.2394, 30.0) 
  and (-0.4363, 29.914) .. (-0.59, 29.7606).. controls (-0.8112, 29.5394) and 
  (-0.8049, 29.2658) .. (-0.8049, 28.888).. controls (-0.8049, 28.5099) and 
  (-0.8112, 28.2366) .. (-0.59, 28.0154).. controls (-0.4363, 27.8616) and 
  (-0.2394, 27.7756) .. (0.0, 27.7756).. controls (0.4085, 27.7756) and (0.7281,
   28.0093) .. (0.8049, 28.467) -- (0.3717, 28.467).. controls (0.3289, 28.2919)
   and (0.218, 28.1564) .. (0.0032, 28.1564).. controls (-0.1138, 28.1564) and 
  (-0.209, 28.1995) .. (-0.2704, 28.2702).. controls (-0.3535, 28.3625) and 
  (-0.3778, 28.467) .. (-0.3778, 28.888).. controls (-0.3778, 29.3089) and 
  (-0.3535, 29.4132) .. (-0.2704, 29.5052).. controls (-0.209, 29.5761) and 
  (-0.1138, 29.619) .. (0.0032, 29.619).. controls (0.218, 29.619) and (0.3289, 
  29.4841) .. (0.3717, 29.3089) -- (0.8049, 29.3089).. controls (0.7281, 
  29.7666) and (0.4056, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-34.0929, 158.5302)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 29.0843) -- 
  (-0.7406, 29.0843) -- (-0.7406, 30.0) -- (-1.1676, 30.0) -- (-1.1676, 27.8124)
   -- (-0.7406, 27.8124) -- (-0.7406, 28.7065) -- (0.0, 28.7065) -- (0.0, 
  27.8124) -- (0.427, 27.8124) -- (0.427, 30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-31.3045, 158.5302)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.8662, 28.6575) -- 
  (-0.8662, 30.0) -- (-1.2935, 30.0) -- (-1.2935, 27.8124) -- (-0.9125, 27.8124)
   -- (-0.046, 29.152) -- (-0.046, 27.8124) -- (0.381, 27.8124) -- (0.381, 30.0)
   -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-28.9309, 160.6657)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.0614, 29.9294)
   and (-0.1566, 29.8833) .. (-0.2733, 29.8833).. controls (-0.3903, 29.8833) 
  and (-0.4884, 29.9294) .. (-0.5498, 30.0).. controls (-0.6329, 30.0926) and 
  (-0.6543, 30.1939) .. (-0.6543, 30.6144).. controls (-0.6543, 31.0356) and 
  (-0.6329, 31.1369) .. (-0.5498, 31.2293).. controls (-0.4884, 31.2996) and 
  (-0.3903, 31.3457) .. (-0.2733, 31.3457).. controls (-0.1566, 31.3457) and 
  (-0.0614, 31.2996) .. (0.0, 31.2293).. controls (0.0831, 31.1369) and (0.1077,
   31.0356) .. (0.1077, 30.6144).. controls (0.1077, 30.1939) and (0.0831, 
  30.0926) .. (0.0, 30.0)(0.3164, 31.4872).. controls (0.163, 31.6407) and 
  (-0.0246, 31.7267) .. (-0.2733, 31.7267).. controls (-0.5223, 31.7267) and 
  (-0.7125, 31.6407) .. (-0.8665, 31.4872).. controls (-1.0874, 31.266) and 
  (-1.0814, 30.9927) .. (-1.0814, 30.6144).. controls (-1.0814, 30.2368) and 
  (-1.0874, 29.9632) .. (-0.8665, 29.742).. controls (-0.7125, 29.5883) and 
  (-0.5223, 29.5023) .. (-0.2733, 29.5023).. controls (-0.0246, 29.5023) and 
  (0.163, 29.5883) .. (0.3164, 29.742).. controls (0.5379, 29.9632) and (0.5347,
   30.2368) .. (0.5347, 30.6144).. controls (0.5347, 30.9927) and (0.5379, 
  31.266) .. (0.3164, 31.4872);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-27.7168, 158.5302)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 27.8124) -- (0.427, 
  27.8124) -- (0.427, 29.6187) -- (1.4195, 29.6187) -- (1.4195, 30.0) -- (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-24.3489, 160.6657)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.0616, 29.9294)
   and (-0.1566, 29.8833) .. (-0.2736, 29.8833).. controls (-0.3903, 29.8833) 
  and (-0.4884, 29.9294) .. (-0.5501, 30.0).. controls (-0.6329, 30.0926) and 
  (-0.6543, 30.1939) .. (-0.6543, 30.6144).. controls (-0.6543, 31.0356) and 
  (-0.6329, 31.1369) .. (-0.5501, 31.2293).. controls (-0.4884, 31.2996) and 
  (-0.3903, 31.3457) .. (-0.2736, 31.3457).. controls (-0.1566, 31.3457) and 
  (-0.0616, 31.2996) .. (0.0, 31.2293).. controls (0.0828, 31.1369) and (0.1074,
   31.0356) .. (0.1074, 30.6144).. controls (0.1074, 30.1939) and (0.0828, 
  30.0926) .. (0.0, 30.0)(0.3164, 31.4872).. controls (0.1627, 31.6407) and 
  (-0.0246, 31.7267) .. (-0.2736, 31.7267).. controls (-0.5223, 31.7267) and 
  (-0.7128, 31.6407) .. (-0.8665, 31.4872).. controls (-1.0877, 31.266) and 
  (-1.0816, 30.9927) .. (-1.0816, 30.6144).. controls (-1.0816, 30.2368) and 
  (-1.0877, 29.9632) .. (-0.8665, 29.742).. controls (-0.7128, 29.5883) and 
  (-0.5223, 29.5023) .. (-0.2736, 29.5023).. controls (-0.0246, 29.5023) and 
  (0.1627, 29.5883) .. (0.3164, 29.742).. controls (0.5376, 29.9632) and 
  (0.5345, 30.2368) .. (0.5345, 30.6144).. controls (0.5345, 30.9927) and 
  (0.5376, 31.266) .. (0.3164, 31.4872);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-21.4491, 158.8182)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.1752, 30.1812)
   and (-0.3842, 30.2487) .. (-0.6178, 30.2487).. controls (-0.8573, 30.2487) 
  and (-1.0538, 30.1627) .. (-1.2076, 30.0093).. controls (-1.4288, 29.7881) and
   (-1.4227, 29.5145) .. (-1.4227, 29.1364).. controls (-1.4227, 28.7588) and 
  (-1.4288, 28.4853) .. (-1.2076, 28.2641).. controls (-1.0538, 28.1103) and 
  (-0.8636, 28.0244) .. (-0.6178, 28.0244).. controls (-0.1109, 28.0244) and 
  (0.1474, 28.3561) .. (0.2056, 28.725) -- (-0.2244, 28.725).. controls 
  (-0.2736, 28.5189) and (-0.3995, 28.4054) .. (-0.6178, 28.4054).. controls 
  (-0.7342, 28.4054) and (-0.8297, 28.4514) .. (-0.8911, 28.522).. controls 
  (-0.9742, 28.6144) and (-0.9956, 28.716) .. (-0.9956, 29.1364).. controls 
  (-0.9956, 29.5576) and (-0.9742, 29.6621) .. (-0.8911, 29.7542).. controls 
  (-0.8297, 29.8248) and (-0.7342, 29.868) .. (-0.6178, 29.868).. controls 
  (-0.4887, 29.868) and (-0.3842, 29.8217) .. (-0.3135, 29.7449).. controls 
  (-0.2429, 29.665) and (-0.2154, 29.5669) .. (-0.2154, 29.4534) -- (-0.2154, 
  29.37) -- (-0.6178, 29.37) -- (-0.6178, 29.0136) -- (0.2088, 29.0136) -- 
  (0.2088, 29.3333).. controls (0.2088, 29.6497) and (0.1535, 29.8405) .. (0.0, 
  30.0);
    \end{scope}
    \path[fill=c001e61,nonzero rule] (-20.6461, 121.0302) -- (-20.1126, 
  121.0302) -- (-20.1126, 123.7645) -- (-20.6461, 123.7645) -- cycle;
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-18.5609, 158.5074)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.2397, 30.0) 
  and (-0.4363, 29.914) .. (-0.59, 29.7606).. controls (-0.8112, 29.5394) and 
  (-0.8051, 29.2658) .. (-0.8051, 28.888).. controls (-0.8051, 28.5099) and 
  (-0.8112, 28.2366) .. (-0.59, 28.0154).. controls (-0.4363, 27.8616) and 
  (-0.2397, 27.7756) .. (-0.0, 27.7756).. controls (0.4085, 27.7756) and 
  (0.7281, 28.0093) .. (0.8049, 28.467) -- (0.3717, 28.467).. controls (0.3289, 
  28.2919) and (0.2183, 28.1564) .. (0.0032, 28.1564).. controls (-0.1138, 
  28.1564) and (-0.209, 28.1995) .. (-0.2704, 28.2702).. controls (-0.3535, 
  28.3625) and (-0.3778, 28.467) .. (-0.3778, 28.888).. controls (-0.3778, 
  29.3089) and (-0.3535, 29.4132) .. (-0.2704, 29.5052).. controls (-0.209, 
  29.5761) and (-0.1138, 29.619) .. (0.0032, 29.619).. controls (0.2183, 29.619)
   and (0.3289, 29.4841) .. (0.3717, 29.3089) -- (0.8049, 29.3089).. controls 
  (0.7281, 29.7666) and (0.4056, 30.0) .. (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-16.214, 160.4583)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.2768, 30.7959) -- 
  (0.2672, 30.7959) -- cycle(0.5099, 31.5425) -- (0.3807, 31.1554) -- (-0.3963, 
  31.1554) -- (-0.5286, 31.5425) -- (-0.9742, 31.5425) -- (-0.1783, 29.3549) -- 
  (0.1566, 29.3549) -- (0.9554, 31.5425) -- (0.5099, 31.5425);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-14.6817, 158.5302)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 27.8124) -- (0.427, 
  27.8124) -- (0.427, 29.6187) -- (1.4195, 29.6187) -- (1.4195, 30.0) -- (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-41.4863, 154.8879)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.4487, 30.0) 
  and (-0.8051, 29.6957) .. (-0.8051, 29.2319) -- (-0.8051, 27.7939) -- 
  (-0.3781, 27.7939) -- (-0.3781, 29.2166).. controls (-0.3781, 29.4682) and 
  (-0.2305, 29.619) .. (0.0, 29.619).. controls (0.2305, 29.619) and (0.3807, 
  29.4682) .. (0.3807, 29.2166) -- (0.3807, 27.7939) -- (0.8049, 27.7939) -- 
  (0.8049, 29.2319).. controls (0.8049, 29.6957) and (0.4485, 30.0) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-38.268, 154.911)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.8662, 28.6575) -- 
  (-0.8662, 30.0) -- (-1.2933, 30.0) -- (-1.2933, 27.8127) -- (-0.9125, 27.8127)
   -- (-0.046, 29.152) -- (-0.046, 27.8127) -- (0.381, 27.8127) -- (0.381, 30.0)
   -- (0.0, 30.0);
    \end{scope}
    \path[fill=c001e61,nonzero rule] (-37.1538, 117.411) -- (-36.62, 117.411) --
   (-36.62, 120.1453) -- (-37.1538, 120.1453) -- cycle;
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-34.9878, 154.911)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.3196, 30.0) -- 
  (-1.0414, 27.8127) -- (-0.599, 27.8127) -- (-0.1598, 29.2383) -- (0.2797, 
  27.8127) -- (0.7252, 27.8127) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-33.7509, 154.911)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 27.8127) -- (1.4409,
   27.8127) -- (1.4409, 28.1934) -- (0.427, 28.1934) -- (0.427, 28.7065) -- 
  (1.2904, 28.7065) -- (1.2904, 29.0877) -- (0.427, 29.0877) -- (0.427, 29.6193)
   -- (1.4409, 29.6193) -- (1.4409, 30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-30.3904, 157.1692)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (-0.4024, 30.0) -- 
  (-0.4024, 30.5779) -- (0.0, 30.5779).. controls (0.1876, 30.5779) and (0.3104,
   30.458) .. (0.3104, 30.2889).. controls (0.3104, 30.1199) and (0.1876, 30.0) 
  .. (0.0, 30.0)(0.3321, 31.8066) -- (-0.0953, 30.934) -- (-0.4024, 30.934) -- 
  (-0.4024, 31.8066) -- (-0.8295, 31.8066) -- (-0.8295, 29.6193) -- (0.0278, 
  29.6193).. controls (0.4731, 29.6193) and (0.7374, 29.9233) .. (0.7374, 
  30.2889).. controls (0.7374, 30.5964) and (0.5501, 30.7869) .. (0.3381, 
  30.8636) -- (0.8266, 31.8066) -- (0.3321, 31.8066);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-28.1626, 154.8879)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0).. controls (-0.3318, 30.0) 
  and (-0.5837, 29.9294) .. (-0.7988, 29.7111) -- (-0.5223, 29.4346).. controls 
  (-0.3842, 29.573) and (-0.1966, 29.619) .. (0.0064, 29.619).. controls 
  (0.2582, 29.619) and (0.3932, 29.5235) .. (0.3932, 29.3486).. controls 
  (0.3932, 29.2719) and (0.3717, 29.2073) .. (0.3257, 29.1642).. controls 
  (0.2826, 29.1245) and (0.2334, 29.1028) .. (0.1323, 29.0875) -- (-0.132, 
  29.0507).. controls (-0.3196, 29.0229) and (-0.4577, 28.9644) .. (-0.5562, 
  28.8694).. controls (-0.6604, 28.7649) and (-0.7128, 28.6234) .. (-0.7128, 
  28.4395).. controls (-0.7128, 28.049) and (-0.4239, 27.7754) .. (0.0492, 
  27.7754).. controls (0.35, 27.7754) and (0.5686, 27.8492) .. (0.7559, 28.0307)
   -- (0.4855, 28.2979).. controls (0.3471, 28.1656) and (0.1812, 28.1474) .. 
  (0.0368, 28.1474).. controls (-0.1905, 28.1474) and (-0.3011, 28.2733) .. 
  (-0.3011, 28.4239).. controls (-0.3011, 28.4792) and (-0.2826, 28.5376) .. 
  (-0.2365, 28.5805).. controls (-0.1937, 28.6205) and (-0.1228, 28.6541) .. 
  (-0.0339, 28.6665) -- (0.2244, 28.7035).. controls (0.4241, 28.7311) and 
  (0.5501, 28.7864) .. (0.6421, 28.8723).. controls (0.7588, 28.9829) and 
  (0.8112, 29.1428) .. (0.8112, 29.3364).. controls (0.8112, 29.7603) and 
  (0.4577, 30.0) .. (0.0, 30.0);
    \end{scope}
    \path[fill=c001e61,nonzero rule] (-26.6455, 117.411) -- (-26.1117, 117.411) 
  -- (-26.1117, 120.1453) -- (-26.6455, 120.1453) -- cycle;
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-24.4293, 157.1692)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 31.8066) -- (-0.427,
   31.8066) -- (-0.427, 30.0) -- (-0.9985, 30.0) -- (-0.9985, 29.6193) -- 
  (0.5715, 29.6193) -- (0.5715, 30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-22.2362, 156.0325)}]
      \path[fill=c001e61,nonzero rule] (0.0, 30.0) -- (0.0, 30.8972) -- 
  (-0.4239, 30.8972) -- (-0.4239, 30.0) -- (-1.0814, 28.7096) -- (-0.6175, 
  28.7096) -- (-0.2088, 29.5915) -- (0.1937, 28.7096) -- (0.6575, 28.7096) -- 
  (0.0, 30.0);
    \end{scope}
    \path[fill=ce01932,nonzero rule] (-42.7692, 116.1668) -- (-21.4852, 
  116.1668) -- (-21.4852, 116.4148) -- (-42.7692, 116.4148) -- cycle;
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-41.8918, 150.3939)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0).. controls (-0.2717, 30.0) 
  and (-0.4781, 29.9421) .. (-0.6543, 29.7635) -- (-0.4278, 29.5367).. controls 
  (-0.3146, 29.6502) and (-0.1609, 29.6878) .. (0.005, 29.6878).. controls 
  (0.2117, 29.6878) and (0.3223, 29.6097) .. (0.3223, 29.4663).. controls 
  (0.3223, 29.4034) and (0.3048, 29.3504) .. (0.267, 29.3153).. controls 
  (0.2315, 29.2827) and (0.1916, 29.2653) .. (0.1085, 29.2523) -- (-0.1082, 
  29.2224).. controls (-0.2617, 29.1996) and (-0.3749, 29.1517) .. (-0.4553, 
  29.0737).. controls (-0.5411, 28.9882) and (-0.5839, 28.8723) .. (-0.5839, 
  28.7213).. controls (-0.5839, 28.4017) and (-0.3471, 28.1776) .. (0.0405, 
  28.1776).. controls (0.2871, 28.1776) and (0.4659, 28.2379) .. (0.6194, 
  28.3866) -- (0.3977, 28.6056).. controls (0.2847, 28.4972) and (0.1487, 
  28.4824) .. (0.0304, 28.4824).. controls (-0.1558, 28.4824) and (-0.2466, 
  28.5853) .. (-0.2466, 28.7086).. controls (-0.2466, 28.7541) and (-0.2315, 
  28.802) .. (-0.1937, 28.8369).. controls (-0.1585, 28.87) and (-0.1005, 
  28.8975) .. (-0.0275, 28.9075) -- (0.1839, 28.9377).. controls (0.3474, 
  28.9602) and (0.4509, 29.0057) .. (0.5263, 29.0761).. controls (0.6218, 
  29.1671) and (0.6646, 29.2978) .. (0.6646, 29.4563).. controls (0.6646, 
  29.8037) and (0.3752, 30.0) .. (0.0, 30.0);
    \end{scope}
    \path[fill=ce01932,nonzero rule] (-40.0824, 112.9124) -- (-39.6452, 
  112.9124) -- (-39.6452, 115.1526) -- (-40.0824, 115.1526) -- cycle;
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-37.2318, 150.4124)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0) -- (-0.7096, 28.8999) -- 
  (-0.7096, 30.0) -- (-1.0597, 30.0) -- (-1.0597, 28.208) -- (-0.7474, 28.208) 
  -- (-0.0376, 29.3052) -- (-0.0376, 28.208) -- (0.3122, 28.208) -- (0.3122, 
  30.0) -- (0.0, 30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-34.3714, 150.6486)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0).. controls (-0.1437, 30.1487)
   and (-0.3149, 30.2037) .. (-0.5059, 30.2037).. controls (-0.7025, 30.2037) 
  and (-0.8636, 30.1334) .. (-0.9893, 30.0074).. controls (-1.1705, 29.8264) and
   (-1.1655, 29.6023) .. (-1.1655, 29.2928).. controls (-1.1655, 28.9829) and 
  (-1.1705, 28.7591) .. (-0.9893, 28.5776).. controls (-0.8636, 28.4519) and 
  (-0.7075, 28.3815) .. (-0.5059, 28.3815).. controls (-0.0908, 28.3815) and 
  (0.1207, 28.6533) .. (0.1685, 28.9554) -- (-0.1839, 28.9554).. controls 
  (-0.2241, 28.7869) and (-0.3273, 28.6935) .. (-0.5059, 28.6935).. controls 
  (-0.6017, 28.6935) and (-0.6797, 28.7313) .. (-0.73, 28.7893).. controls 
  (-0.798, 28.8647) and (-0.8157, 28.9478) .. (-0.8157, 29.2928).. controls 
  (-0.8157, 29.6375) and (-0.798, 29.723) .. (-0.73, 29.7987).. controls 
  (-0.6797, 29.8566) and (-0.6017, 29.8918) .. (-0.5059, 29.8918).. controls 
  (-0.4003, 29.8918) and (-0.3149, 29.854) .. (-0.2569, 29.791).. controls 
  (-0.199, 29.7256) and (-0.1762, 29.6449) .. (-0.1762, 29.5521) -- (-0.1762, 
  29.4841) -- (-0.5059, 29.4841) -- (-0.5059, 29.192) -- (0.1709, 29.192) -- 
  (0.1709, 29.4539).. controls (0.1709, 29.7129) and (0.1257, 29.869) .. (0.0, 
  30.0);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-32.427, 151.9923)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0) -- (-0.2265, 30.6519) -- 
  (0.2191, 30.6519) -- cycle(0.4178, 31.2637) -- (0.3122, 30.9464) -- (-0.3246, 
  30.9464) -- (-0.4329, 31.2637) -- (-0.798, 31.2637) -- (-0.1461, 29.4716) -- 
  (0.1283, 29.4716) -- (0.7829, 31.2637) -- (0.4178, 31.2637);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-29.7587, 152.2625)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0) -- (-0.3273, 30.0) -- 
  (-0.3273, 30.4905) -- (0.0, 30.4905).. controls (0.1588, 30.4905) and (0.259, 
  30.3924) .. (0.259, 30.2466).. controls (0.259, 30.1005) and (0.1588, 30.0) ..
   (0.0, 30.0)(0.0175, 30.8054) -- (-0.3273, 30.8054) -- (-0.3273, 31.4801) -- 
  (-0.6771, 31.4801) -- (-0.6771, 29.6878) -- (0.0175, 29.6878).. controls 
  (0.3876, 29.6878) and (0.6091, 29.9421) .. (0.6091, 30.2466).. controls 
  (0.6091, 30.5511) and (0.3876, 30.8054) .. (0.0175, 30.8054);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-27.0308, 152.162)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0).. controls (-0.05, 29.9421) 
  and (-0.1281, 29.9045) .. (-0.2238, 29.9045).. controls (-0.3196, 29.9045) and
   (-0.4001, 29.9421) .. (-0.4503, 30.0).. controls (-0.5183, 30.0754) and 
  (-0.536, 30.1588) .. (-0.536, 30.5035).. controls (-0.536, 30.8483) and 
  (-0.5183, 30.9316) .. (-0.4503, 31.007).. controls (-0.4001, 31.0647) and 
  (-0.3196, 31.1025) .. (-0.2238, 31.1025).. controls (-0.1281, 31.1025) and 
  (-0.05, 31.0647) .. (0.0, 31.007).. controls (0.0683, 30.9316) and (0.0884, 
  30.8483) .. (0.0884, 30.5035).. controls (0.0884, 30.1588) and (0.0683, 
  30.0754) .. (0.0, 30.0)(0.2593, 31.2181).. controls (0.1336, 31.3441) and 
  (-0.0201, 31.4147) .. (-0.2238, 31.4147).. controls (-0.4278, 31.4147) and 
  (-0.5839, 31.3441) .. (-0.7096, 31.2181).. controls (-0.8909, 31.0372) and 
  (-0.8858, 30.8131) .. (-0.8858, 30.5035).. controls (-0.8858, 30.1937) and 
  (-0.8909, 29.9698) .. (-0.7096, 29.7886).. controls (-0.5839, 29.6627) and 
  (-0.4278, 29.5923) .. (-0.2238, 29.5923).. controls (-0.0201, 29.5923) and 
  (0.1336, 29.6627) .. (0.2593, 29.7886).. controls (0.4408, 29.9698) and 
  (0.4382, 30.1937) .. (0.4382, 30.5035).. controls (0.4382, 30.8131) and 
  (0.4408, 31.0372) .. (0.2593, 31.2181);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-24.6205, 152.2625)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0) -- (-0.3297, 30.0) -- 
  (-0.3297, 30.4728) -- (0.0, 30.4728).. controls (0.1535, 30.4728) and (0.2543,
   30.3749) .. (0.2543, 30.2365).. controls (0.2543, 30.0979) and (0.1535, 30.0)
   .. (0.0, 30.0)(0.272, 31.4801) -- (-0.0781, 30.7652) -- (-0.3297, 30.7652) --
   (-0.3297, 31.4801) -- (-0.6795, 31.4801) -- (-0.6795, 29.6878) -- (0.0228, 
  29.6878).. controls (0.3876, 29.6878) and (0.604, 29.937) .. (0.604, 
  30.2365).. controls (0.604, 30.4884) and (0.4506, 30.6443) .. (0.2768, 
  30.7072) -- (0.6773, 31.4801) -- (0.272, 31.4801);
    \end{scope}
    \begin{scope}[cm={ 1.25,-0.0,-0.0,-1.25,(-22.8458, 150.4124)}]
      \path[fill=ce01932,nonzero rule] (0.0, 30.0) -- (0.0, 28.208) -- (1.1806, 
  28.208) -- (1.1806, 28.5199) -- (0.35, 28.5199) -- (0.35, 28.9401) -- (1.0573,
   28.9401) -- (1.0573, 29.2523) -- (0.35, 29.2523) -- (0.35, 29.6878) -- 
  (1.1806, 29.6878) -- (1.1806, 30.0) -- (0.0, 30.0);
    \end{scope}
  \end{scope}
\end{tikzpicture}%
}

\makeatother
