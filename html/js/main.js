
// - FilterableCommentTable
//   - SearchBar
//   - CommentTable
//     - CommentRow

RegExp.escape = function(string) {
  return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
};

String.prototype.splice = function(idx, rem, str) {
    return this.slice(0, idx) + str + this.slice(idx + Math.abs(rem));
};

var MIN_SEARCH_CHARS = 1;

var CommentRow = React.createClass({
  render: function() {
    var comment = this.props.comment;
    var searchWords = this.props.match || [];
    var currentPos = 0;
    var boldBegin = "<b>";
    var boldEnd = "</b>";

    // change words into bold
    for (var i = 0; i < searchWords.length; i++) {
      var searchWord = searchWords[i];
      var pos = comment.toLowerCase().indexOf(searchWord, currentPos);
      comment = comment
        .splice(pos, 0, boldBegin) // insert <b>
        .splice(pos + boldBegin.length + searchWord.length, 0, boldEnd); // insert </b>
      currentPos = pos + boldBegin.length + searchWord.length + boldEnd.length; // update currentPos
    }

    return (
      <tr>
        <td dangerouslySetInnerHTML={{__html: comment}}></td>
      </tr>
    );
  }
});

function isMatched(str, words) {
  var currentPos = 0;
  for (var i = 0; i < words.length; i++) {
    currentPos = str.toLowerCase().indexOf(words[i], currentPos);
    if (currentPos === -1) return false;
  }
  return true;
}

var CommentTable = React.createClass({
  addRowNum: function () {
    this.props.changeRowNum(
      this.props.maxRowNum + 100
    );
  },
  render: function () {
    var filterText = this.props.filterText
      .replace(/\s+/g, ' ') // squeeze whitespace
      .trim();              // strip
    if (filterText.length < MIN_SEARCH_CHARS) return (<table></table>);

    var searchWords = filterText.split(" ");
    var maxRowNum = this.props.maxRowNum;
    var rows =
      this.props.comments.filter(function (comment) {
        return isMatched(comment, searchWords);
      })
      .slice(0, maxRowNum)
      .map(function (comment) {
        return (<CommentRow comment={comment} key={comment} match={searchWords} />);
      });

    if (rows.length >= maxRowNum) {
      rows.push(
        <tr key="more...">
          <td><button className="btn btn-default" onClick={this.addRowNum}>more...</button></td>
        </tr>
      );
    }

    return (
      <table className={"table"}>
        <tbody>
          {rows}
        </tbody>
      </table>
    );
  }
});

var SearchBar = React.createClass({
  handleChange: function() {
    this.props.onUserInput(
      this.refs.filterTextInput.value
    );
  },
  render: function () {
    return (
      <form className={"form-inline"}>
        <input
          type="text"
          placeholder="Search..."
          value={this.props.filterText}
          ref="filterTextInput"
          onChange={this.handleChange}
        />
      </form>
    );
  }
});

var FilterableCommentTable = React.createClass({
  getInitialState: function () {
    return {
      filterText: '',
      maxRowNum: 100
    };
  },
  handleUserInput: function (filterText) {
    this.setState({ filterText: filterText, maxRowNum: 100 });
  },
  changeMaxRowNum: function (maxRowNum) {
    this.setState({ maxRowNum: maxRowNum });
  },
  render: function () {
    return (
      <div>
        <SearchBar
          filterText={this.state.filterText}
          onUserInput={this.handleUserInput}
        />
        <CommentTable
          comments={this.props.comments}
          filterText={this.state.filterText}
          maxRowNum={this.state.maxRowNum}
          changeRowNum={this.changeMaxRowNum}
        />
      </div>
    );
  }
});

var comments = [];
var getDatabaseC = jQuery.get("database/js")
  .done(function (data) {
    Array.prototype.push.apply(comments, data.split("\n"));
  });

$.when(getDatabaseC)
  .done(function () {
    ReactDOM.render(
      <FilterableCommentTable comments={comments} />,
      document.getElementById('react')
    );
  });
