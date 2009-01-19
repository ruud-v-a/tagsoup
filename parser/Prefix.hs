
import Data.List
import Data.Char

data Tag = Comment String
	 | OpenStart String
	 | OpenShut
	 | OpenFinish
	 | OpenAtt String String
	 | Text String
	 | Close String
	 | Warning String
	 | Pos Position
	   deriving Show

type Position = ()


endBy str (s0,p0,w0)
	| str `isPrefixOf` s0 = ("",(drop (length str) s0,p0,w0))
	| null s0 = ("",(s0,p0,w0))
	| otherwise = (head s0:v,spw)
		where (v,spw) = endBy str (tail s0,p0,w0)

literal str (s0,p0,w0) | str `isPrefixOf` s0 = (str,(drop (length str) s0,p0,w0))
		       | otherwise = ("",(s0,p0,w0++[Warning $ "Expected " ++ str]))

clearWarn (s0,p0,w0) = ("",(s0,p0,[]))


name (s0,p0,w0) = (a,(b,p0,w0))
	where (a,b) = span isAlphaNum s0

spaces (s0,p0,w0) = (a,(b,p0,w0))
	where (a,b) = span isSpace s0


entityNameHashX x = entityName ("#x" ++ x)
entityNameHash x = entityName ("#" ++ x)
entityName x = [Text $ "&" ++ x ++ ";"]


takeWhileNot str (s0,p0,w0) = (a,(b,p0,w0))
	where (a,b) = span (`notElem` str) s0

innerText xs = concatMap f xs
	where
		f (Text x) = x
		f _ = ""