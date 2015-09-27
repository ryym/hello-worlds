package hello;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * throw IllegalStateException when request to /ambiguous/xxx.
 */
@RestController("/ambiguous")
public class AmbiguousController {

    @RequestMapping("/{name}")
    public String consumeName(@PathVariable("name") String name) {
        return String.format("hello, %s!", name);
    }

    @RequestMapping("/{year}")
    public String consumeYear(@PathVariable("year") Integer year) {
        return year.toString() + " year!!";
    }

}
