require 'test_helper'

module Hopscotch
  class BrokerTest < Minitest::Test
    def setup
      @connection = mock
      @broker = Broker.new(@connection)
    end

    def teardown
      @broker.instance_variable_set(:@channel, nil)
    end

    def test_start_connection_calls_start_on_bunny
      @connection.expects(:start).once
      @broker.start_connection!
    end

    def test_create_channel_creates_a_new_bunny_channel
      refute @broker.channel
      channel = mock
      @connection.expects(:create_channel).once.returns(channel)
      @broker.create_channel!
      assert @broker.channel
      assert_equal channel, @broker.channel
    end

    def test_close_channel_returns_if_channel_not_set
      refute @broker.channel
      @broker.close_channel
      refute @broker.channel
    end

    def test_close_channel_calls_close_on_channel_if_set
      refute @broker.channel
      channel = mock
      @broker.instance_variable_set(:@channel, channel)
      assert @broker.channel
      channel.expects(:close).once
      @broker.close_channel
      refute @broker.channel
    end

    def test_close_closes_channel_and_connection
      channel = mock
      @broker.instance_variable_set(:@channel, channel)
      assert @broker.channel
      assert @broker.connection
      @connection.expects(:close).once
      channel.expects(:close).once

      @broker.close

      refute @broker.channel
    end

    def test_ack_raises_error_if_no_connection

      @broker.expects(:connection).returns(nil)

      error = assert_raises "StandardError" do
        @broker.ack('hello')
      end

      assert_equal 'No connection', error.message

    end

    def test_ack_raises_error_if_no_channel

      @broker.expects(:channel).returns(nil)

      error = assert_raises "StandardError" do
        @broker.ack('hello')
      end

      assert_equal 'No channel', error.message

    end

    def test_ack_calls_ack_on_channel_with_tag

      channel = mock
      @broker.expects(:channel).at_least_once.returns(channel)

      channel.expects(:ack).once.with('hello', false)

      @broker.ack('hello')

    end

    def test_reject_raises_error_if_no_connection

      @broker.expects(:connection).returns(nil)

      error = assert_raises "StandardError" do
        @broker.reject('hello')
      end

      assert_equal 'No connection', error.message

    end

    def test_reject_raises_error_if_no_channel

      @broker.expects(:channel).returns(nil)

      error = assert_raises "StandardError" do
        @broker.reject('hello')
      end

      assert_equal 'No channel', error.message

    end

    def test_reject_calls_reject_on_channel_with_tag

      channel = mock
      @broker.expects(:channel).at_least_once.returns(channel)

      channel.expects(:reject).once.with('hello', false)

      @broker.reject('hello')

    end

    def test_reject_calls_reject_on_channel_with_tag_and_requeue_true_when_specified

      channel = mock
      @broker.expects(:channel).at_least_once.returns(channel)

      channel.expects(:reject).once.with('hello', true)

      @broker.reject('hello', true)

    end

    def test_create_exchange_creates_a_bunny_exchange

      channel = mock

      @broker.instance_variable_set(:@channel, channel)

      Bunny::Exchange.expects(:new).with(channel, 'topic', 'hello', {durable: true})

      @broker.create_exchange!('hello')

    end

    def test_connect_to_exchange_creates_channel_if_not_exists

      @connection.expects(:start).returns(true)

      @broker.expects(:create_channel!).once
      @broker.expects(:create_exchange!).with('hello').once

      @broker.connect_to_exchange!('hello')

    end

    def test_queue_should_return_a_channel_queue_with_prefetch_specified

      channel = mock

      @broker.expects(:start_connection!).returns(true)

      @connection.expects(:create_channel).once.returns(channel)

      channel.expects(:prefetch).with(10).once
      channel.expects(:queue).with('hello', {durable: true}).once

      @broker.queue('hello', prefetch: 10)

    end

    def test_data_exchange_connects_to_exchange_with_hopscotch_data_exchange_name

      @broker.expects(:connect_to_exchange!).with('hopscotch.data').once

      @broker.data_exchange

    end

    def test_system_exchange_connects_to_exchange_with_hopscotch_system_exchange_name

      @broker.expects(:connect_to_exchange!).with('hopscotch.system').once

      @broker.system_exchange

    end

  end
end