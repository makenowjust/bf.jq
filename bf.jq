# Brainfuck interpreter written in jq
# Author: MakeNowJust
# License: http://makenowjust.mit-license.org/2014

# define while syntax
# look like:
# while(
#  condition(cond)|
#  do(body)
# )
def condition(cond): .__cond__=cond;
def do(body): if .__cond__ then body else . end;
def while(body): body|
  if .__cond__ then while(body) else .__cond__=true end;

# assert Brainf*ck state
def assert(cond; msg): if cond then . else error(msg) end;

# initialize state
{
  pc: 0,
  pt: 0,
  mem: [0],
  input: explode,
  st: [],
  stlen: 0,
  output: []
}|

# main loop
while(
  condition(.pc < (.input|length))|
  do(
    . as $current|
    .input[.pc]|
    if   . == 43 then # == '+'
      $current|.mem[.pt]|=(.+1)%256
    elif . == 45 then # == '-'
      $current|.mem[.pt]|=(.+255)%256
    elif . == 60 then # == '<'
      $current|.pt-=1|assert(.pt>=0; "bf.jq: memory underflow")
    elif . == 62 then # == '>'
      $current|.pt+=1|.mem[.pt]//=0
    elif . == 46 then # == '.'
      $current|.output[.output|length]=(.mem[.pt]//0)
    elif . == 91 then # == '['
      $current|
      if .mem[.pt] == 0 then
        .count=1|.pc+=1|
        while(
          condition(.count > 0 and .pc < (.input|length))|
          do(
            . as $current|
            .input[.pc]|
            if   . == 91 then # == '['
              $current|.count+=1
            elif . == 93 then # == ']'
              $current|.count-=1
            else
              $current
            end|
            .pc+=1
          )
        )|
        assert(.count == 0; "bf.jq: not found `]'")|
        .pc-=1
      else
        .st[.stlen]=.pc|.stlen+=1
      end
    elif . == 93 then # == ']'
      $current|.stlen-=1|.pc=((.st[.stlen]//0)-1)|assert(.stlen>=0; "bf.jq: not found `['")
    else
      $current
    end|
    .pc+=1
  )
)|
# check error
assert(.stlen == 0; "bf.jq: not found `]'")|
# print
.output|implode
