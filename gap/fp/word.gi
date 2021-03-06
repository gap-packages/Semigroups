#############################################################################
##
##  word.gi
##  Copyright (C) 2020                                      Maria Tsalakou
##
##  Licensing information can be found in the README file of this package.
##
#############################################################################
##

InstallMethod(WordToString, "for a string and a list",
[IsString, IsList],
function(alphabet, word)
  local str, i;
  if Length(word) = 0 then
    return "";
  fi;
  for i in word do
    if not IsPosInt(i) then
      ErrorNoReturn("Semigroups: WordToString: usage,\n",
                    "expected list of positive integers as second argument,");
    fi;
  od;
  if Maximum(word) > Length(alphabet) then
    ErrorNoReturn("Semigroups: WordToString: usage,\n",
                  "there are not enough letters in the alphabet,");
  fi;
  str := "";
  for i in word do
     Add(str, alphabet[i]);
  od;
  return str;
end);

InstallMethod(RandomWord, "for two non-negative integers",
[IsInt, IsInt],
function(length, number_letters)
  local word, i;
  if length < 0 then
    ErrorNoReturn("expected non-negative integer as first argument");
  elif number_letters < 0 then
    ErrorNoReturn("expected non-negative integer as second argument");
  elif number_letters = 0 and length > 0 then
    ErrorNoReturn("first argument cannot be positive if second is zero");
  fi;
  word := EmptyPlist(length);
  for i in [1 .. length] do
      Add(word, Random([1 .. number_letters]));
  od;
  return word;
end);

InstallMethod(StandardiseWord, "for a list of positive integers",
[IsList],
function(w)
  local L, distinct_chars, lookup, i;

  L := Length(w);
  if L = 0 then
    return w;
  fi;

  for i in w do
    if not IsPosInt(i) then
      ErrorNoReturn("expected a list of positive integers as argument");
    fi;
  od;

  distinct_chars := 1;
  lookup         := [];
  lookup[w[1]]   := 1;
  w[1]           := 1;

  for i in [2 .. L] do
    if IsBound(lookup[w[i]]) then
      w[i] := lookup[w[i]];
    else
      distinct_chars := distinct_chars + 1;
      lookup[w[i]]   := distinct_chars;
      w[i]           := distinct_chars;
    fi;
  od;
  return w;
end);

InstallMethod(StringToWord, "for a string", [IsString],
w -> StandardiseWord(List(w, IntChar)));
