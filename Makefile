NAME	=	program

CC		=	g++
DB		=	lldb

CFLAGS	=	-Wall
CFLAGS	+=	-Wextra
CFLAGS	+=	-Werror
CFLAGS	+=	-g
CFLAGS	+=	-Wfatal-errors
CFLAGS	+=	-std=c++98

OFLAGS	=	-fsanitize=address


#	Sources

SRCD	=	src

SRCS	=	$(SRCD)/main.cpp
SRCS	+=	$(SRCD)/f/f.cpp


#	Headers

INCD	=	inc

INCS	+=	$(INCD)/f.hpp

#	Objets

OBJD	=	objs
OBJS	=	$(patsubst $(SRCD)/%.cpp, $(OBJD)/%.o, $(SRCS))

RM		=	rm -rf


all : $(NAME)

$(NAME):	$(OBJS)
	@printf "$(YELLOW)Creating executable..$(DEFAULT)\n"
	@$(CC) $(OBJS) $(OFLAGS) -o $(NAME)
	@printf "$(GREEN)---> $(NAME) is ready$(DEFAULT)\n"

$(OBJD)/%.o: $(SRCD)/%.cpp
	@mkdir -p $(@D)
	@$(CC) -c $(<) $(CFLAGS) -I$(INCD) -o $(@)

clean:
	@$(RM) $(OBJD)
	@printf "$(RED)Removed $(CYAN)$(OBJD)$(DEFAULT)\n"

fclean: clean
	@$(RM) $(NAME)
	@printf "$(RED)Removed $(CYAN)$(NAME)$(DEFAULT)\n"

re:	fclean all


db: all
	$(DB) $(NAME)

format:
	@cat $(SRCS) $(INCS) $(TMPS) > /tmp/before
	@clang-format -i $(SRCS) $(INCS) $(TMPS)
	@cat $(SRCS) $(INCS) $(TMPS) > /tmp/after
	@diff -u --color=auto /tmp/before /tmp/after || true


doc:
	asciidoctor README.adoc -o index.html


.PHONY: all clean fclean libclean fullclean

#COLORS
RED = \033[1;31m
GREEN = \033[1;32m
YELLOW = \033[1;33m
CYAN = \033[1;36m
DEFAULT = \033[0m
