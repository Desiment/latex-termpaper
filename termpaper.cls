\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{termpaper}[2026/01/06 MatMex LaTeX Term Paper Class]

% ============================================================================
% REQUIRE LuaLaTeX
% ============================================================================
\RequirePackage{iftex}
\RequireLuaTeX

% ============================================================================
% PACKAGE REQUIREMENTS
% ============================================================================
\RequirePackage{xparse}     % Enhanced command definitions
\RequirePackage{kvoptions}  % Key-value options
\RequirePackage{luaboolean} % Lua boolean utilities
\RequirePackage{fontswitch} % Dynamic font size switching

% ============================================================================
% DEFAULT CONFIGURATION
% ============================================================================
\def\termpaper@fontsize{12pt}       % Default font size
\def\termpaper@baseclass{article}   % Default base class

\NewDocumentCommand\SetupTitlePageGeometry{}{
  \newgeometry{top=20mm,bottom=20mm,left=20mm,right=15mm,nohead,includeheadfoot}%
}
\NewDocumentCommand\SetupBodyPageGeometry{}{%
  \newgeometry{top=20mm,bottom=20mm,left=30mm,right=15mm,nohead,includeheadfoot}%
}
% Called before title page
\NewDocumentCommand\SetupTitlePage{}{
  \SetupTitlePageGeometry
} 
% Called after title page
\NewDocumentCommand\SetupBodyPage{}{%
  \SetupBodyPageGeometry
}

%
% ============================================================================
% CLASS OPTIONS
% ============================================================================
\newif\if@termpaper@gost
\newif\if@termpaper@extfont

\SetupKeyvalOptions{prefix=termpaper@}
\DeclareStringOption[{title/records-template.lua}]{titleconf}     % Filename for title configuration
% Option: gost
% Ensures all things are done in compliance with GOST
\DeclareOption{gost}{%
  \@termpaper@gosttrue
  \@termpaper@extfonttrue
}
% Option: 14pt
% Switches to 14pt font size with extarticle base class
\DeclareOption{14pt}{%
  \@termpaper@extfonttrue
}

% Process all class options
\ProcessKeyvalOptions*   
\ProcessOptions\relax

% ============================================================================
% LOAD BASE CLASS WITH CONFIGURED OPTIONS
% ============================================================================
\if@termpaper@extfont
  \def\termpaper@fontsize{14pt}%
  \def\termpaper@baseclass{extarticle}%
\fi
\LoadClass[a4paper,\termpaper@fontsize]{\termpaper@baseclass}


\if@termpaper@extfont
  % Keep title in 12pt font
  \RenewDocumentCommand\SetupTitlePage{}{%
	\SetPageFontSize{12}%
	\SetupTitlePageGeometry
  }%
  % Body text uses requested 14pt font
  \RenewDocumentCommand\SetupBodyPage{}{%
	\SetPageFontSize{14}%
	\SetupBodyPageGeometry
  }%
\fi

\if@termpaper@gost
  \RenewDocumentCommand\SetupBodyPageGeometry{}{%
	\newgeometry{top=20mm,bottom=20mm,left=30mm,right=15mm,nohead,includeheadfoot,footskip=35pt}%
  }
  % Title already redefined correctly due to extfont bool
  % Body text should adopt a few things still
  \RenewDocumentCommand\SetupBodyPage{}{%
	\SetPageFontSize{14}%
	\SetupBodyPageGeometry
    % Межстрочный интервал = 1.5pt
	\onehalfspacing
	% Абзацный отступ = 1.25см
	\setlength\parindent{12.5mm}
  }%
\fi
% ============================================================================
% LOCALIZATION 
% ============================================================================

\RequirePackage{fontspec}
\setmainfont{CMU Serif}
\setsansfont{CMU Sans Serif}
\setmonofont{CMU Typewriter Text}
%\setmonofont{Fira Code}[Contextuals=Alternate,Scale=0.9]
%\setmonofont{Inconsolata}

% Русский язык
\RequirePackage[babelshorthands]{polyglossia}
\setmainlanguage{russian}
\setotherlanguage{english}

% Smart quotes based on current language
\RequirePackage[autostyle]{csquotes}

% ============================================================================
% PAGE LAYOUT AND TYPOGRAPHY
% ============================================================================

\RequirePackage[a4paper]{geometry}  % Page dimensions and margins
\RequirePackage{setspace}    % Настройка межстрочного интервала
\RequirePackage{indentfirst} % Пакет для абзацных отступов в начале раздела
\RequirePackage{tocloft}     % Пакет для настройки содержания
\RequirePackage{titlesec}    % Пакет для настройки заголовков разделов
\RequirePackage{fancyhdr}    % Настройка колонтитулов 
\RequirePackage{enumitem}    % Настройка списков
\RequirePackage{microtype}   % Микротипография
\setdisplayskipstretch{1.0}  % Отступы вокруг выключных формул

\if@termpaper@gost
  %%%%%%%%%%%%%%
  %   Разделы  %
  %%%%%%%%%%%%%%
  % Размеры заголовков разделов и подразделов
  % Раздел: 18pt, добавляем слово "Глава"
  \titleformat{\section}%
  {\fontsize{18}{18}\bfseries}{\hspace{-1.5mm}Глава \thesection. }{0em}{}
  % Подраздел: 16pt
  \titleformat{\subsection}%
  {\fontsize{16}{16}\bfseries}{\hspace{-0.2mm}\thesubsection. }{0em}{}
  % Команды для специальных разделов (введение, обзор литературы, etc)
  % Не нумеруются в содержании, по уровню вложенности
  \NewDocumentCommand{\specialsection}{om}{
	  \clearpage
	  \vspace{3.5ex plus 1ex minus .2ex}

	  \phantomsection
	  \hspace{-13.8mm}\normalfont\fontsize{18}{18}\textbf{#2}\par
	  \vspace{2.3ex plus .2ex}
	  \normalfont\normalsize
	  \IfNoValueTF{#1}{%
		\addcontentsline{toc}{section}{#2}%
	  }{%
		\addcontentsline{toc}{section}{#1}%
	  }%
  }
  \NewDocumentCommand{\specialsubsection}{om}{
	  \vspace{3.25ex plus 1ex minus .2ex}
	  
	  \phantomsection
	  \hspace{-12.5mm}\normalfont\fontsize{16}{16}\textbf{#2}\par
	  \vspace{1.5ex plus .2ex}
	  \normalfont\normalsize
	  \IfNoValueTF{#1}{%
		\addcontentsline{toc}{subsection}{\hspace{-1pt}#2}%
	  }{%
		\addcontentsline{toc}{subsection}{#1}%
	  }%
  }

  %%%%%%%%%%%%%%
  % Сожержание %
  %%%%%%%%%%%%%%
  % Выравнивание заголовка по центру (да, да, хак с отступом слева \hspace{0.31\textwidth})
  % т.к. окружение center и \centering не работают
  \renewcommand{\cfttoctitlefont}{\hspace{0.31\textwidth} \bfseries\Large}
  \renewcommand{\cftbeforetoctitleskip}{-1em}
  % Слово "Глава" в содержании
  \renewcommand{\cftsecpresnum}{Глава\space}
  \newlength\cftsecpresnumlength
  \settowidth\cftsecpresnumlength{\cftsecpresnum}
  \addtolength\cftsecnumwidth{\cftsecpresnumlength}
  % Строки с точками
  \renewcommand{\cftsecleader}{\cftdotfill{\cftdotsep}}
  % Точки после цифр в в содержании
  \renewcommand{\cftsecaftersnum}{.}
  \renewcommand{\cftsubsecaftersnum}{.}
  % Подровнять subsection под точку главы
  % (если глав будет больше десяти, будет чуть хуже)
  \setlength{\cftsubsecindent}{2.68em}
  % Интервал глав
  \setlength{\cftbeforesecskip}{4pt}
  \renewcommand{\cftsecpagefont}{\normalfont}

  %%%%%%%%%%%%%%
  %   Списки   %
  %%%%%%%%%%%%%%
  \AddEnumerateCounter{\asbuk}{\russian@asbuk@alph}{щ}
  % Для первого уровня списков (уровень 1)
  \setlist[itemize,1]{
	  itemsep=.5\parskip,
	  topsep=0mm,
	  partopsep=0mm,
	  listparindent=\parindent,
	  parsep=\parskip,
	  leftmargin=0mm,
	  itemindent=\parindent,
	  labelsep=2mm,
	  label=\textendash
  }

  \setlist[enumerate,1]{
	  itemsep=.5\parskip,
	  topsep=0mm,
	  partopsep=0mm,
	  listparindent=\parindent,
	  parsep=\parskip,
	  leftmargin=0mm,
	  itemindent=\parindent,
	  labelsep=2mm,
	  label=\asbuk*)
  }

  % Для второго уровня списков (уровень 2)
  \setlist[itemize,2]{
	  itemsep=.5\parskip,
	  topsep=0mm,
	  partopsep=\parskip,
	  listparindent=1.5em,
	  parsep=\parskip,
	  leftmargin=2\parindent,
	  itemindent=0mm,
	  labelsep=2mm,
	  label=--
  }

  \setlist[enumerate,2]{
	  itemsep=.5\parskip,
	  topsep=0mm,
	  partopsep=\parskip,
	  listparindent=1.5em,
	  parsep=\parskip,
	  leftmargin=2\parindent,
	  itemindent=0mm,
	  labelsep=2mm,
	  label=\arabic*)
  }
\fi

\ProvideDocumentCommand{\specialsection}{om}{
	\section*{#2}
	\IfNoValueTF{#1}{%
	  \addcontentsline{toc}{section}{#2}%
	}{%
	  \addcontentsline{toc}{section}{#1}%
	}%
}

\ProvideDocumentCommand{\specialsubsection}{om}{
	\subsection*{#2}
	\IfNoValueTF{#1}{%
	  \addcontentsline{toc}{subsection}{#2}%
	}{%
	  \addcontentsline{toc}{subsection}{#1}%
	}%
}

% ============================================================================
% TITLE CONFIGURATION LOADING
% Reads title configuration from Lua file (default: title.lua)
% Custom path can be specified via class option: title={custom/path.lua}
% ============================================================================
\directlua{titleconf = require('titleloader.lua').readconf('\termpaper@titleconf')}
\input{title/base.tex}

