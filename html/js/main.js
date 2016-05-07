
// - FilterableCommentTable
//   - SearchBar
//   - CommentTable
//     - CommentRow

RegExp.escape = function(string) {
  return string.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&')
};

var MIN_SEARCH_CHARS = 5;

var CommentRow = React.createClass({
  render: function() {
    var comment = this.props.comment;
    var searchWords = this.props.match;

    for (var i = 0; i < searchWords.length; i++) {
      comment = comment.replace(
        new RegExp(RegExp.escape(searchWords[i].replace('/', '')), "i"),
        "<b>$&</b>"
      );
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
  render: function () {
    var interactive = (this.props.filterText.length >= MIN_SEARCH_CHARS);
    var searchWords = this.props.filterText.split(" ") || [""];

    var rows =
      this.props.comments.filter(function (comment) {
        if (!interactive) return false;
        return isMatched(comment, searchWords);
      })
      .map(function (comment) {
        return (<CommentRow comment={comment} key={comment} match={searchWords} />);
      });

    return (
      <table>
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
      <form>
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
    return { filterText: '' };
  },
  handleUserInput: function (filterText) {
    this.setState({ filterText: filterText });
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
