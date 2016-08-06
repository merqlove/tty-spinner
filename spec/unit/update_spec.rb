# coding: utf-8

RSpec.describe TTY::Spinner, '#update' do
  let(:output) { StringIO.new('', 'w+') }

  it "updates message content with custom token" do
    spinner = TTY::Spinner.new(":title :spinner", output: output, interval: 100)
    spinner.update(title: 'task')
    5.times { spinner.spin }
    output.rewind
    expect(output.read).to eq([
      "\e[1Gtask |",
      "\e[1Gtask /",
      "\e[1Gtask -",
      "\e[1Gtask \\",
      "\e[1Gtask |",
    ].join)

    spinner.update(title: 'TEEEST')
    5.times { spinner.spin }
    spinner.stop('done')
    output.rewind
    expect(output.read).to eq([
      "\e[1Gtask |",
      "\e[1Gtask /",
      "\e[1Gtask -",
      "\e[1Gtask \\",
      "\e[1Gtask |",
      "\e[TEEEST '|",
      "\e[TEEEST /",
      "\e[TEEEST -",
      "\e[TEEEST \\",
      "\e[TEEEST |",
      "\e[TEEEST | done\n",
    ].join)
  end

  it "maintains current tokens" do
    spinner = TTY::Spinner.new(":foo :bar", output: output)
    expect(spinner.tokens).to eq({})

    spinner.update(foo: 'FOO')
    spinner.update(bar: 'BAR')

    expect(spinner.tokens).to include({foo: 'FOO', bar: 'BAR'})
  end
end
