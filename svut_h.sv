// Copyright 2017 Damien Pretet ThotIP
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.


`ifndef INFO
`define INFO(msg) \
    $display("INFO:    [%0t]: %s", $time, msg)
`endif

`ifndef WARNING
`define WARNING(msg) \
    $display("WARNING: [%0t]: %s", $time, msg)
`endif

`ifndef ERROR
`define ERROR(msg) \
    $display("ERROR:   [%0t]: %s", $time, msg)
`endif

`ifndef SVUT_SETUP
`define SVUT_SETUP \
    integer svut_timeout = 0; \
    integer svut_error = 0;
`endif

`ifndef SVUT_TIMEOUT
`define SVUT_TIMEOUT 1000
`endif

`ifndef SVUT_SET_TIMEOUT
`define SVUT_SET_TIMEOUT(value) \
    `SVUT_TIME_OUT=value;
`endif

`ifndef FAIL_IF
`define FAIL_IF(exp) \
    if (exp) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_EQUAL
`define FAIL_IF_EQUAL(a,b) \
    if (a === b) \
        svut_error = svut_error + 1
`endif

`ifndef FAIL_IF_NOT_EQUAL
`define FAIL_IF_NOT_EQUAL(a,b) \
    if (a !== b) \
        svut_error = svut_error + 1
`endif

`define UNIT_TESTS \
    task automatic run(); \
    begin

`define UNIT_TEST(TESTNAME) \
        setup(); \
        svut_error = 0; \
        svut_timeout = 0; \
        fork : TESTNAME \
            begin \

`define UNIT_TEST_END \
                disable TESTNAME; \
            end \
            begin \
                if (`SVUT_TIMEOUT != 0) begin \
                    while (svut_timeout < `SVUT_TIMEOUT) begin \
                        #1; \
                        svut_timeout = svut_timeout + 1; \
                    end \
                    `ERROR("Timeout reached!"); \
                    $stop(); \
                end \
            end \
        join \
        #0; \
        teardown();

`define UNIT_TESTS_END \
    end \
    endtask \
    initial begin\
        run(); \
        $finish(); \
    end

