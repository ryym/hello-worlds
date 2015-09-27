package sample.curry;


import java.util.function.BiFunction;
import java.util.function.Function;

/**
 * <p>Represents a function that can be curried. </p>
 *
 */
@FunctionalInterface
public interface Curry<T, R> extends Function<T, R> {

    public static interface Curry2<T, U, R> extends Curry<T, Curry<U, R>> {}

    public static interface Curry3<T, U, V, R> extends Curry<T, Curry2<U, V, R>> {}

    public static interface Curry4<T, U, V, W, R> extends Curry<T, Curry3<U, V, W, R>> {}

    public static interface TerFunction<T, U, V, R> {R apply(T a1, U a2, V a3);}

    public static interface QuadFunction<T, U, V, W, R> {R apply(T a1, U a2, V a3, W a4);}

    public static <T, U, R> Curry2<T, U, R> curry2(BiFunction<T, U, R> func) {
        return arg1 -> arg2 -> func.apply(arg1, arg2);
    }

    public static <T, U, V, R> Curry3<T, U, V, R> curry3(TerFunction<T, U, V, R> func) {
        return arg1 -> arg2 -> arg3 -> func.apply(arg1, arg2, arg3);
    }

    public static <T, U, V, W, R> Curry4<T, U, V, W, R> curry4(QuadFunction<T, U, V, W, R> func) {
        return arg1 -> arg2 -> arg3 -> arg4 -> func.apply(arg1, arg2, arg3, arg4);
    }
}
