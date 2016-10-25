## unreleased

### Fixed/Added/Deprecated/Removed

 * ...

## 0.3.0 / 2016-10-26

### Added

 * `specify_each` replaces `each_row`
 * **BREAKING**: the block you pass to `specify_each` will be wrapped in an it-block.
 
    This means that an error will occur if your block contains an it-block **or** specify_each is wrapped in an it-block (i.e. in all cases ;).  
    Solution: remove any it-block surrounding or contained in the specify_each-block.

 * Have a default description
 
    The format is `first: "Foo", last: "Bar" yields "Foo Bar"`.  
    Customize this by passing `desc: "full_name(%{first}, %{last}) => %{result}"` to `specify_each`

### Deprecated

 * `each_row`. Use `specify_each` instead.