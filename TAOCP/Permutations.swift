//
//  Permutations.swift
//  TAOCP
//
//  Created by Robert McCraith on 05/07/2015.
//  Copyright © 2015 Robert McCraith. All rights reserved.
//

import Foundation

class Permutations {
	
	
	func run(){
		let permutationArray = ["(a,c,f,g)", "(b,c,d)","(a,e,d)","(f,a,d,e)","(b,g,f,a,e)"]
		
		print("before: "+"".join(permutationArray))
		print("Algorithm A: "+multiply(permutationArray))
		print("Algorithm B"+onePass(permutationArray))

		let numPerm = [6,2,1,5,4,3]
		print("\n\nbefore \(numPerm)")
		print("Algorithm I: \(inverseI(numPerm)) ")
		print("Algorithm J: \(inverseJ(numPerm)) ")
	}
	
	
	//Split into elements, for convinience and multi character element labels
	func parse(arr: [String])->[String]{
		let regex = try! NSRegularExpression(pattern: "([A-za-z])+", options: NSRegularExpressionOptions.CaseInsensitive)
		var permutations: [String] = []
		
		for(var i = 0; i < arr.count; i++) {
			let cycle = arr[i]
			let elememts = regex.matchesInString(cycle, options: NSMatchingOptions.WithoutAnchoringBounds , range: NSMakeRange(0, cycle.characters.count))
			
			if elememts.count > 0 {
				
				permutations.append("(")
				
				for a in elememts {
					Range<String.Index>(start: advance(cycle.startIndex, a.range.location), end: cycle.endIndex)
					let range = Range<String.Index>(start: advance(cycle.startIndex, a.range.location), end: advance(cycle.startIndex, a.range.length+a.range.location))
					
					permutations.append(cycle.substringWithRange(range))
				}
				permutations.append(")")
			}
		}
		
		return permutations
	}
	
	//Algorithm A
	func multiply(arr : [String])->String{
		
		var permutations = parse(arr)
		
		//replace ) with first element in cycle and tag them and first two in string
		var first = ""
		var tagged: [Int] = [0,1]
		for(var i = 1; i < permutations.count;i++){
			if permutations[i-1] == "("{
				first = permutations[i]
			}else if permutations[i] == ")" {
				permutations[i] = first
				tagged.append(i)
			}
		}
		
		
		var ans = ""
		var current = ""
		for(var i = 0; i < permutations.count; i++){
			
			if permutations[i] == "(" || (tagged.contains(i) && i != 1){ //skip ('s and tagged elements
				continue
			}
			
			//A2 Find first untagged and set as start
			let start = permutations[i]
			ans = ans.stringByAppendingString("(")
			ans = ans.stringByAppendingString(start)
			tagged.append(i)
			
			//A3 set current as next element
			current = permutations[i+1]
			
			//scan right until reaching element same as current or end
			while current != start{
				
				for(var j = i+2; j < permutations.count-1; j++){
					if current == permutations[j] && permutations[j+1] != "(" && !tagged.contains(j){
						//if element same as current reached tag it and (A£) set next element as current
						current = permutations[++j]
						
						tagged.append(j-1)
					}
				}
				//A4 if current is not same as start repeat from left
				if current != start {
					ans = ans.stringByAppendingString(current)
				}
			}
			//A5 Close cycle
			ans = ans.stringByAppendingString(")")
		}
		
		
		return ans
		
	}
	//use this to print out untagged elements
	func printTagged(per: [String], tag : [Int]){
		var str = ""
		for(var i = 0; i < per.count; i++){
			if tag.contains(i) {
				str = str.stringByAppendingString("_")
			}else{
				str = str.stringByAppendingString(per[i])
			}
		}
		print(str)
	}
	
	//Algorithm B
	func onePass(arr : [String])->String{
		//1 make T[k] array
		//table holding current permutation state
		var auxTable:[String] = Array(Set(parse(arr))).sort()
		auxTable.removeAtIndex(0)
		auxTable.removeAtIndex(0)
		
		//original order array
		var origin = auxTable
		
		//2 right to left:
		//		if ) then z=0 and repeat 2
		//		if ( goto 4
		//		else element is x_i for some i, goto 3
		
		
		
		
		let perms = parse(arr)
		var z = ""
		var j = 0
		for(var i = perms.count-1; i >= 0; i--){
			if perms[i] == ")" {
				//z = 0, in our case this is )
				z = ")"
			}else if perms[i] == "(" {
				//T[j] = z, closes each cycle at the front
				auxTable[j] = z
			}else{
				//3 exchange Z <=> T[i]
				let temp = auxTable[origin.indexOf(perms[i])!]

				let index = origin.indexOf(perms[i])!
				auxTable[index] = z
				z = temp
				if auxTable[index] == ")" {
					j = index
				}
			}
		}
		
		//changes the output to disjoint cycle notation
		var ansArr:[String] = []
		while auxTable.count > 0 {
			var arr:[String] = []
			//get pre-image of first object left
			let first = origin[0]
			//get image
			var current = auxTable[0]
			arr.append("(")//add for print later
			arr.append(first)
			while current != first {
				arr.append(current)
				current = auxTable[origin.indexOf(current)!]//get element after current by getting its index in pre-images and getting the corresponding image under permutation
			}
			arr.append(")")
			ansArr.append("".join(arr))
			
			//remove used elements in pre-image and image so that they are not used in next loop iteration
			auxTable = auxTable.filter{element in !arr.contains(element)}
			origin = origin.filter{e in !arr.contains(e)}
		}
		return "".join(ansArr)
	}
	
	
	//Algorithm I(inverse in place)
	func inverseI(array :[Int])->[Int]{
		var arr = array
		var m = arr.count-1
		var j = -1
		
		while m >= 0{
			var i = arr[m]
			while i > 0{
				
				arr[m] = j
				j = -(m+1)
				m = i-1
				i = arr[m]
				if i < 0 {
					i=j
				}
			}

			arr[m] = -i
			m--

		}
		return arr
	}
	
	
	func inverseJ(array: [Int])->[Int]{
		var arr = array
		
		//1 negate all
		arr = arr.map({-$0})
		var m = arr.count
		
		while m > 0{
			//2
			var j = m
			
			//3
			var i = arr[j-1]
			while i > 0 {
				j = i
				i = arr[j-1]
			}
			
			//4
			arr[j-1] = arr[-i-1]
			arr[-i-1] = m
			
			m--
		}
	
		
		
		
		
		
		
		return arr
	}
	
	
}