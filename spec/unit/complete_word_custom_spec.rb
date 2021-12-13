# frozen_string_literal: true

RSpec.describe TTY2::Reader, "complete word" do
  let(:input)  { StringIO.new }
  let(:output) { StringIO.new }
  let(:env)    { {"TTY2_TEST" => true} }
  let(:left)   { "\e[D" }
  let(:shift_tab) { "\e[Z" }
  let(:completion_handler) {
    ->(word, context) { @completions }
  }
  let(:options) {
    {input: input, output: output, env: env,
     completion_handler: completion_handler,
     completion_suffix: " ",
     completion_cycling: false}
  }

  subject(:reader) { described_class.new(**options) }

  it "finds no completions for a word at the beginning of a line" do
    @completions = %w[aa ab ac]
    input << "x" << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("x")
  end

  it "partially completes an empty line up to where it is unumbigious" do
    @completions = %w[aaaa aaab aaba]
    input << "" << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("aa")
  end

  it "partially completes a word at the beginning of a line up to where it is unumbigious" do
    @completions = %w[aaaaa aaaab aaaba]
    input << "a" << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("aaa")
  end

  it "partially completes a word within a line up to where it is unumbigious" do
    @completions = %w[aaaa aaab aaba]
    input << "foo a bar"
    input << "\e[D" << "\e[D" << "\e[D" << "\e[D"
    input << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("foo aa bar")
  end

  it "partially completes a word at the end of a line up to where it is unumbigious" do
    @completions = %w[aaaaa aaaab aaaba]
    input << "xyz a" << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("xyz aaa")
  end

  it "fully completes an empty line" do
    @completions = %w[aaa]
    input << "" << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("aaa\s")
  end

  it "fully completes a word at the beginning of a line" do
    @completions = %w[aaaaa abaaa aabaa]
    input << "aab" << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("aabaa\s")
  end

  it "fully completes a word within a line" do
    @completions = %w[aaaa abaa aaba]
    input << "foo aab bar"
    input << "\e[D" << "\e[D" << "\e[D" << "\e[D"
    input << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("foo aaba\s bar")
  end

  it "fully completes a word at the end of a line" do
    @completions = %w[aaaaa abaaa aabaa]
    input << "xyz aab" << "\t"
    input.rewind

    answer = reader.read_line

    expect(answer).to eq("xyz aabaa\s")
  end
end
