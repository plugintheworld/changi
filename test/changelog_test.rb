require_relative './test_helper.rb'

class ChangelogTest < MiniTest::Test
  include TestHelper

  def setup
    setup_root
  end

  def teardown
    teardown_root
  end

  def test_new_entry
    cli.expect :say, nil, [String]
    cli.expect :choose, 'Category'
    changelog.new_entry
    cli.verify

    assert_equal 1, entries_count
    assert_equal({ category: 'Category', text: ['Multiline'] }, YAML.load_file(last_entry_yaml))
  end

  def test_render_demo
    test_new_entry

    exp = {
      changelog: {
        version: '<version>',
        notes: '<notes>',
        entries: [{
          category: 'Category',
          text: 'Multiline'
        }]
      }
    }

    assert_equal exp, YAML.load(changelog.render(demo: true))
  end

  def test_render
    test_new_entry

    exp = {
      changelog: {
        version: 'v1',
        notes: 'Notes',
        entries: [{
          category: 'Category',
          text: 'Multiline'
        }]
      }
    }

    cli.expect :ask, 'v1', [String]
    cli.expect :ask, 'Notes', [String]
    assert_equal exp, YAML.load(changelog.render)
  end

  def test_update
    test_new_entry

    cli.expect :ask, 'v1', [String]
    cli.expect :ask, 'Notes', [String]
    changelog.update

    assert_equal entries_count, 0
    assert File.exist?(TestHelper.changelog_path)

    exp = {
      changelog: {
        version: 'v1',
        notes: 'Notes',
        entries: [{
          category: 'Category',
          text: 'Multiline'
        }]
      }
    }

    assert_equal exp, YAML.load_file(TestHelper.changelog_path)
  end
end
