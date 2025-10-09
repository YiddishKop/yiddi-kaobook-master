%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% kaobook
% LaTeX Class
% Version 0.9.8 (2021/08/23)
%
% This template originates from:
% https://www.LaTeXTemplates.com
%
% For the latest template development version and to make contributions:
% https://github.com/fmarotta/kaobook
%
% Authors:
% Federico Marotta (federicomarotta@mail.com)
% Based on the doctoral thesis of Ken Arroyo Ohori (https://3d.bk.tudelft.nl/ken/en)
% and on the Tufte-LaTeX class.
% Modified for LaTeX Templates by Vel (vel@latextemplates.com)
%
% License:
% LPPL (see included MANIFEST.md file)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%----------------------------------------------------------------------------------------
%	CLASS CONFIGURATION
%----------------------------------------------------------------------------------------

\NeedsTeXFormat{LaTeX2e}  %指定需要LaTeX2e格式。

\ProvidesClass{kaobook}[2021/08/23 v0.9.8 kaobook]% 定义类名称和版本
\newcommand{\@baseclass}{scrbook}   %设置基础类为 KOMA-Script 的 scrbook 

% 定义类名称和版本 : 传递a4paper、10pt字体、半行段距、以及标题选项给基础类。
\PassOptionsToClass{a4paper}{\@baseclass}
\PassOptionsToClass{fontsize=10pt}{\@baseclass}
\PassOptionsToClass{parskip=half}{\@baseclass}
\PassOptionsToClass{headings=optiontoheadandtoc}{\@baseclass} %标题同时出现在页眉和目录中

% 将任何未明确处理的选项传递给基础类。
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{\@baseclass}} 

\ProcessOptions\relax % 处理选项。 Process the options

\LoadClass{\@baseclass} % 加载 scrbook 类 。 Load the base class

\RequirePackage{kao} % 加载kao.sty，这个包可能包含了一些通用设置。 Load the code common to all classes

%----------------------------------------------------------------------------------------
%	 重新定义前言、正文、后记和附录的行为 FRONT-, MAIN-, BACK- MATTERS BEHAVIOUR
%    保存旧的\frontmatter, \mainmatter, \appendix, \backmatter命令，然后重新定义它们。
%    在重定义的命令中，除了调用旧命令，还设置了页面样式、页面布局和章节样式。
%----------------------------------------------------------------------------------------

% Front matter
\let\oldfrontmatter\frontmatter % 保存原命令，重新定义前言格式 Store the old command
\renewcommand{\frontmatter}{%
	\oldfrontmatter% First of all, call the old command
	\pagestyle{plain.scrheadings}% 使用简洁的页眉页脚样式 Use a plain style for the header and the footer
	\pagelayout{wide}% 使用宽页面布局 Use a wide page layout
	\setchapterstyle{plain} %  设置章节样式为普通样式 Choose the default chapter heading style
	% \sloppy % Required to better break long lines
}

%------------------------------------------------

% Main matter
\let\oldmainmatter\mainmatter % Store the old command
\renewcommand{\mainmatter}{%
	\oldmainmatter% Call the old command
	\pagestyle{scrheadings}% 使用花式页眉页脚 Use a fancy style for the header and the footer
	\pagelayout{margin}%  使用边注布局（1.5 栏） Use a 1.5 column layout
	\setchapterstyle{kao} % 设置章节样式为 kao 样式 Choose the default chapter heading style
}

%------------------------------------------------

% Appendix
\let\oldappendix\appendix% Store the old command
\renewcommand{\appendix}{%
	\oldappendix% Call the old command
	\bookmarksetup{startatroot}% Reset the bookmark depth
}

%------------------------------------------------

% Back matter
\let\oldbackmatter\backmatter% Store the old command
\renewcommand{\backmatter}{%
	\oldbackmatter% Call the old command
	\bookmarksetup{startatroot}% Reset the bookmark depth
	\pagestyle{plain.scrheadings}% Use a plain style for the header and the footer
	\pagelayout{wide}% Use a wide page layout
	\setchapterstyle{plain} % Choose the default chapter heading style
}

%----------------------------------------------------------------------------------------
%	CHAPTER HEADING STYLES
%----------------------------------------------------------------------------------------

% Command to easily switch between chapter styles
% \setchapterstyle 命令允许在四种章节样式（plain, bar, lines, kao）之间切换。
%----------------------------------------------------------------------------------------
% \DeclareDocumentCommand 是 xparse 包提供的一个更强大的命令定义接口。语法 \DeclareDocumentCommand{\cmd}{<arg-spec>}{<code>}。
% 这里 m 表示一个必选参数（#1）。
% \ifthenelse{\equal{plain}{#1}}{\chapterstyleplain}{}：使用 ifthen 包的条件判断（\equal 用于字符串比较），当参数与 plain 相等时执行 \chapterstyleplain。
% 依赖提示：要使 \DeclareDocumentCommand 和 \ifthenelse 可用，类或它所 RequirePackage 的文件（例如 kao.sty）
% 需要加载 xparse（通常通过 expl3 / l3kernel 或 xparse）和 ifthen。若你在调试中发现 Undefined control sequence，请检查 kao.sty 是否加载了这些包。
%----------------------------------------------------------------------------------------
\DeclareDocumentCommand{\setchapterstyle}{m}{%
	\ifthenelse{\equal{plain}{#1}}{\chapterstyleplain}{}
	\ifthenelse{\equal{bar}{#1}}{\chapterstylebar}{}
	\ifthenelse{\equal{lines}{#1}}{\chapterstylelines}{}
	\ifthenelse{\equal{kao}{#1}}{\chapterstylekao}{}
}

%----------------------------------------------------------------------------------------
% 每种样式通过重新定义\chapterlinesformat和\chapterformat来实现不同的外观。
% chapterstyleplain: 默认的KOMA样式。
% chapterstylebar: 在章节标题背后放置一个灰色条。
% chapterstylelines: 使用线条装饰章节标题。
% chapterstylekao: 一种自定义样式，根据页面布局（宽版或单列）和奇偶页调整标题布局。
%----------------------------------------------------------------------------------------

% The default definition in KOMA script
%----------------------------------------------------------------------------------------
% \renewcommand{\chapterlinesformat}[3]{...}：\chapterlinesformat 是 KOMA-Script 或模板提供的低层钩子，用来指定章节标题如何排版。它在被调用时会传入 3 个参数（模板中用 ##1/##2/##3 表示，定义时需要写成 ## 来转义 #）。在这里使用 \@hangfrom{##2}{##3}：该内核命令把编号（第二个参数）作为挂起标签，标题文本（第三个参数）靠它对齐。
% \renewcommand*{\chapterformat}{...}：定制章节编号的输出样式。这里用到的宏：
% \chapappifchapterprefix：KOMA 提供的条件宏，若启用了 chapter prefix（例如在某些语言或配置下显示“Chapter”一词）则插入它。
% \nobreakspace：不可断行空格（~ 的命令形式）。
% \thechapter：当前章节编号。
% \autodot：KOMA 的自动句点控制（在需要时自动添加句点/点号）。
% \IfUsePrefixLine：模板可能定义的条件分支，与是否使用“前缀行”有关。
% \RedeclareSectionCommand[beforeskip=0cm,afterskip=10\vscale]{chapter}：KOMA 的 \RedeclareSectionCommand 用来调整 \chapter 的前后垂直间距。
% \setlength{\mtocshift}{-1\vscale}：设置 \mtocshift（模板自定义长度）为 -1\vscale，影响目录/章节在布局中的偏移。\vscale 是模板的缩放长度（在 kao.sty / kao 包里定义），与页面大小相关。
%----------------------------------------------------------------------------------------
\DeclareDocumentCommand{\chapterstyleplain}{}{%
	\renewcommand{\chapterlinesformat}[3]{%
		\@hangfrom{##2}{##3}}
	\renewcommand*{\chapterformat}{%
		\mbox{\chapappifchapterprefix{\nobreakspace}\thechapter%
		\autodot\IfUsePrefixLine{}{\enskip}}}
	\RedeclareSectionCommand[beforeskip=0cm,afterskip=10\vscale]{chapter}
	\setlength{\mtocshift}{-1\vscale}
}

% Gray bar
% 灰色背景条的样式
% 使用 TikZ 创建灰色背景条
% 调整章节前后的间距
%----------------------------------------------------------------------------------------
% 该样式用 tikzpicture 绘制一个覆盖（overlay）节点作为背景灰条，节点内放章节编号与标题（通过 \@hangfrom{##2}{##3}）。
% remember picture, overlay：overlay 让 tikzpicture 在页面内容上层绘制（不会占用正常垂直空间），remember picture 允许跨页引用页面定位。
% xshift=\dimexpr - \hoffset - \oddsidemargin - 1in -1mm 与 inner xsep=\dimexpr \hoffset + \oddsidemargin + 1in：这是利用 TeX 的 \dimexpr 做长度计算，把节点的横向起点对齐到页面的真正左边（把 \hoffset, \oddsidemargin 和 1in（TeX 的 reference offset）考虑进去）。这类写法用于让背景条跨越整个页宽（\paperwidth）。
% fill=gray!20!white：TikZ 的颜色混合语法（20% gray + 80% white）；fill opacity 控制透明度。
% text width=\paperwidth-40\hscale：把节点内部文本宽度设为几乎整页宽度（减去一定的 \hscale 边距），以便文本自动换行。
% \RedeclareSectionCommand[beforeskip=-55\vscale,...]{chapter}：使用负 beforeskip 把正文向上挤，留出给灰条显示的空间（否则灰条会重叠正文或产生空白）。
%----------------------------------------------------------------------------------------
\DeclareDocumentCommand{\chapterstylebar}{}{%
	\renewcommand*{\chapterformat}{%
		\mbox{\chapappifchapterprefix{\nobreakspace}\thechapter%
		\autodot\IfUsePrefixLine{}{\enskip}}%
	}
	\renewcommand{\chapterlinesformat}[3]{%
		\begin{tikzpicture}[remember picture, overlay]
			\node[
				anchor=south west,
				xshift=\dimexpr - \hoffset - \oddsidemargin - 1in -1mm,%-30\hscale,
				yshift=4.3mm,
				rectangle,
				fill=gray!20!white,
				fill opacity=0.8,
				inner ysep=5\vscale,
				inner xsep=\dimexpr \hoffset + \oddsidemargin + 1in,%30\hscale,
				text opacity=1,
				text width=\paperwidth-40\hscale,
			]{\@hangfrom{##2}{##3}};
		\end{tikzpicture}
	}
	\RedeclareSectionCommand[beforeskip=-55\vscale,afterskip=6\vscale]{chapter}
	\setlength{\mtocshift}{-1\vscale}
}

% Lines
% - 线条装饰的样式
% - 使用 \hrulefill 创建水平线
% - 章节编号放大显示
\renewcommand{\hrulefill}[1][0.4pt]{%
	\leavevmode\leaders\hrule height #1\hfill\kern\z@%
}
\DeclareDocumentCommand{\chapterstylelines}{}{%
	\renewcommand*{\chapterformat}{%
		\chapappifchapterprefix{\nobreakspace}\scalebox{3.5}{\thechapter\autodot}%
	}%
	\renewcommand\chapterlinesformat[3]{%
		%\vspace*{-1cm}%
		\leavevmode%
		\makebox[0pt][l]{%
		\makebox[\textwidth][l]{\hrulefill[1pt]##2}%\hfill%\par%\bigskip
		\makebox[\marginparsep][l]{}%
		\makebox[\marginparwidth][l]{}%
		}\\
		%\vspace{.5cm}
		\makebox[0pt][l]{%
		\makebox[\textwidth][l]{##3}%
		\makebox[\marginparsep][l]{}%
		\makebox[\marginparwidth][l]{}%
		}\\
		\makebox[0pt][l]{%
		\makebox[\textwidth+\marginparsep+\marginparwidth][l]{\hrulefill[1.1pt]}%
		}%
	}%
	\RedeclareSectionCommand[beforeskip=0cm,afterskip=10\vscale]{chapter}
	\setlength{\mtocshift}{-1\vscale}%
}

% The Kao style
% - 主要的自定义样式
% - 根据页面布局（宽版/窄版）和奇偶页调整布局
% - 章节编号放大显示
% - 在章节标题旁添加垂直线条
% - 支持双面打印的奇偶页不同布局
\DeclareDocumentCommand{\chapterstylekao}{}{%
    \IfWideLayout{%
        \renewcommand*{\chapterformat}{%
	    	\mbox{\chapappifchapterprefix{\nobreakspace}\scalebox{2.85}{\thechapter\autodot}}%
	    }%
	    \renewcommand\chapterlinesformat[3]{%
	    	\vspace{3.5\vscale}%
	    	\if@twoside%
	    		\Ifthispageodd{%
	    			\smash{\makebox[0pt][l]{%
                        \parbox[b]{\textwidth - 6.2\hscale}{\flushright{##3}}%
                        \makebox[6.2\hscale][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\marginparwidth}{##2}%
	    			}}%
	    		}{
                    \smash{\makebox[\textwidth + 6.2\hscale][r]{%
                        \parbox[b]{47.7\hscale + 6.2\hscale}{\flushright{##2}}%
                        \makebox[6.2\hscale][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\textwidth}{\flushleft{##3}}%
	    			}}%
	    		}
	    	\else%
	    		\smash{\makebox[0pt][l]{%
                    \parbox[b]{\textwidth - 6.2\hscale}{\flushright{##3}}%
                    \makebox[6.2\hscale][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
                    \parbox[b]{\marginparwidth}{##2}%
	    		}}%
	    	\fi%
	    }%
    }{%
        \renewcommand*{\chapterformat}{%
	    	\mbox{\chapappifchapterprefix{\nobreakspace}\scalebox{2.85}{\thechapter\autodot}}%
	    }%
	    \renewcommand\chapterlinesformat[3]{%
	    	\vspace{3.5\vscale}%
	    	\if@twoside%
	    		\Ifthispageodd{%
	    			\smash{\makebox[0pt][l]{%
	    				\parbox[b]{\textwidth}{\flushright{##3}}%
	    				\makebox[\marginparsep][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\marginparwidth}{##2}%
	    			}}%
	    		}{
	    			\smash{\makebox[\textwidth][r]{%
	    				\parbox[b]{\marginparwidth}{\flushright{##2}}%
	    				\makebox[\marginparsep][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    				\parbox[b]{\textwidth}{\flushleft{##3}}%
	    			}}%
	    		}
	    	\else%
	    		\smash{\makebox[0pt][l]{%
	    			\parbox[b]{\textwidth}{\flushright{##3}}%
	    			\makebox[\marginparsep][c]{\rule[-2\vscale]{1pt}{27.4\vscale+\f@size mm}}%
	    			\parbox[b]{\marginparwidth}{##2}%
	    		}}%
	    	\fi%
	    }%
    }%
	\RedeclareSectionCommand[beforeskip=0cm,afterskip=10\vscale]{chapter}%
	\setlength{\mtocshift}{-3.5\vscale}%
}

% Takes as input the image path and optionally the "beforeskip"
% 这个命令允许为章节设置背景图片，并自动调整布局。
\DeclareDocumentCommand{\setchapterimage}{O{55\vscale} m}{%
    % 设置章节前导图像
    % 调整章节样式为 bar
    % 根据图像高度调整间距
	\setchapterpreamble[o]{%
		\vspace*{-27\vscale}\hspace*{\dimexpr - \hoffset - \oddsidemargin - 1in}%
		\includegraphics[width=\paperwidth,height=#1+27\vscale,keepaspectratio=false]{#2}%
	}%
	\chapterstylebar%
	% beforeskip=-(figure_height-top_margin)
	\RedeclareSectionCommand[beforeskip=-#1, afterskip=6\vscale]{chapter}%
	\setlength{\mtocshift}{0cm}%
}

% By default start with the plain style
\chapterstyleplain

%----------------------------------------------------------------------------------------
%	设置字体和样式 FONTS AND STYLES
%----------------------------------------------------------------------------------------

% Set KOMA fonts for book-specific elements
% 设置部分、章节、段落等元素的字体
% - 设置各部分标题的字体样式：
% - 部分 (part)：正常字体、小型大写、粗体
% - 章节 (chapter)：正常字体、粗体
% - 各层级标题都设置为粗体
\addtokomafont{part}{\normalfont\scshape\bfseries}
\addtokomafont{partentry}{\normalfont\scshape\bfseries}
\addtokomafont{chapter}{\normalfont\bfseries}
\addtokomafont{chapterentry}{\normalfont\bfseries}

% Set KOMA fonts for elements common to all classes
% 设置部分、章节、段落等元素的字体
\addtokomafont{section}{\normalfont\bfseries}
\addtokomafont{subsection}{\normalfont\bfseries}
\addtokomafont{subsubsection}{\normalfont\bfseries}
\addtokomafont{paragraph}{\normalfont\bfseries}
\setkomafont{descriptionlabel}{\normalfont\bfseries}

%----------------------------------------------------------------------------------------
%	 设置目录、图表目录和参考文献的选项 TOC, LOF & LOT
%----------------------------------------------------------------------------------------

% Set default options regarding the table of contents
\PassOptionsToClass{toc=listof}{\@baseclass}
\PassOptionsToClass{toc=index}{\@baseclass}
\PassOptionsToClass{toc=bibliography}{\@baseclass}

%----------------------------------------------------------------------------------------
%	NUMBERING
%----------------------------------------------------------------------------------------

%\setcounter{secnumdepth}{\kao@secnumdepth} % Set section numbering depth

\counterwithin*{sidenote}{chapter} % Uncomment to reset the sidenote counter at each chapter
%\counterwithout{sidenote}{chapter} % Uncomment to have one sidenote counter for the whole document
