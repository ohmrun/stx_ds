hxc
===
#Haxe Collection Library

##Collections

imperative / functional

mutable	/ immutable


* List
* DList
* Array
* Hash
* OrderedHash
* IntHash
* Set
* Bag
* Tree
* Graph

The idea is to compose a set of collections using traits as a reuse mechanism and allow for granularity in composition of functionality. Default collections will be imperative and predictable except for some changes of terminology where it clarifies use.

##Notions

###Enumerable 	:
		
Thin shim on iterator, may have slightly different characteristics. For example, is it useful to have available collection changes during iteration?
		
###Traversable : 
		
Two way iterator, with back() and hasBack().

###adjoin / disjoin###

For collections with one entry point i.e stack/queue, doesn't infer any 'endedness'.
		
###Array / Hash###
In this schema there is no real difference between an Array and a Hash at the interface level:

            interface Indexed<V> implements Locatable<Int,V>
		
I think there is a good case for namespacing the existing collections to make it easier to roll your own datastructures.
						
            hx.List
	        stx.fn.List
		
There shouldn't really be too much fooling around about which list is being inferred, and 'FunctionalList' type naming conventions aren't making good use of package names.
		
##Questions
		
Can / Should the base interfaces support both imperative / functional idioms? The return for a set command may be void or some feedback imperatively, but should be the new collection if it is immutable. Typing this may become difficult.
		
    		set(k:K,v:V):C where C : Void
    		set(k:K,v:V):C where C : Enumerable<V>
		
